defmodule StoneChallenge.Banking do
  @moduledoc """
  This module handle Accounts context. Here, we have the functions that realize
  bank transfer and bank draft
  """

  import Ecto.Query, warn: false
  require Logger

  alias StoneChallenge.Repo
  alias StoneChallenge.Banking.Transaction
  alias StoneChallenge.Accounts.{Account, User}
  alias StoneChallenge.Accounts
  alias StoneChallenge.Helper.BankingHelper

  def get_transaction(id) do
    Repo.get(Transaction, id)
  end

  def get_transaction!(id) do
    Repo.get!(Transaction, id)
  end

  def get_transaction_by(params) do
    Repo.get_by(Transaction, params)
  end

  def list_transactions do
    Repo.all(Transaction)
  end

  def realize do
    Repo.all(Transaction)
  end

  def update_account(%Account{} = account, params) do
    account
    |> Account.changeset(params)
    |> Repo.update!()
  end

  def create_draft_transaction(%Account{} = account, amount) do
    db_transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :account,
        Accounts.update_account(
          account,
          %{balance: Decimal.sub(account.balance, amount)}
        )
      )
      |> Ecto.Multi.insert(
        :transaction,
        generate_transaction(amount, account.id, nil, "bank_draft")
      )
      |> Repo.transaction()

    case db_transaction do
      {:ok, operations} -> {:ok, operations.account, operations.transaction}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def bank_draft_transaction(
        conn,
        %{
          "amount" => amount
        }
      ) do
    account = conn.assigns.signed_user.accounts
    Logger.info("TESTANDO ACCOUNT #{inspect(account)}")

    if account != nil do
      cond do
        # Verify if user has money
        amount <= 0 ->
          {:error, "The value should be more than zero"}

        BankingHelper.is_negative_balance(account.balance, amount) ->
          {:error, "You not have money"}

        true ->
          case create_draft_transaction(account, amount) do
            {:ok, account, transaction} -> {:ok, account, transaction}
            {:error, changeset} -> {:error, changeset}
          end
      end
    else
      {:error, "Invalid account"}
    end
  end

  def create_transfer_transaction(
        %Account{} = account_from,
        %Account{} = account_to,
        amount
      ) do
    db_transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :account_from,
        Accounts.update_account(
          account_from,
          %{balance: Decimal.sub(account_from.balance, amount)}
        )
      )
      |> Ecto.Multi.update(
        :account_to,
        Accounts.update_account(
          account_to,
          %{balance: Decimal.add(account_to.balance, amount)}
        )
      )
      |> Ecto.Multi.insert(
        :transaction,
        generate_transaction(amount, account_from.id, account_to.id, "transfer")
      )
      |> Repo.transaction()

    case db_transaction do
      {:ok, operations} -> {:ok, operations.account_from, operations.transaction}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def bank_transfer_transaction(
        conn,
        %{
          "amount" => amount,
          "account_to" => account_to
        }
      ) do
    account_from = conn.assigns.signed_user.accounts

    account_to = Accounts.get_account!(account_to)

    if account_to != nil do
      cond do
        # Verify if user has money
        account_from.id == account_to.id ->
          {:error, "You can't transfer money to your account."}

        amount <= 0 ->
          {:error, "The value should be more than zero"}

        BankingHelper.is_negative_balance(account_from.balance, amount) ->
          {:error, "You not have money"}

        true ->
          case create_transfer_transaction(account_from, account_to, amount) do
            {:ok, account_from, transaction} -> {:ok, account_from, transaction}
            {:error, changeset} -> {:error, changeset}
          end
      end
    else
      {:error, "The account that you trying to transfer not exists"}
    end
  end

  defp generate_transaction(amount, account_from_id, account_to_id, type) do
    %Transaction{
      amount: amount,
      account_from: account_from_id,
      account_to: account_to_id,
      type: type,
      date: Date.utc_today()
    }
  end
end
