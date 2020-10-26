defmodule StoneChallenge.Banking do
  @moduledoc """
  This module handle Accounts context. Here, we have the functions that realize
  bank transfer and bank draft
  """

  import Ecto.Query, warn: false
  require Logger

  alias StoneChallenge.Repo

  alias StoneChallenge.Accounts
  alias StoneChallenge.Accounts.Account
  alias StoneChallenge.Banking.Transaction
  alias StoneChallenge.Helper.BankingHelper
  alias StoneChallenge.Helper.StringsHelper

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
        account_from,
        amount
      ) do
    value = StringsHelper.parse_float(amount)

    if account_from != nil && value != nil do
      cond do
        # Verify if user has money
        Decimal.negative?(value) ->
          {:error, "The amount should be more than zero"}

        BankingHelper.is_negative_balance(account_from.balance, value) ->
          {:error, "You not have money"}

        true ->
          case create_draft_transaction(account_from, value) do
            {:ok, account, transaction} -> {:ok, account, transaction}
            {:error, changeset} -> {:error, changeset}
          end
      end
    else
      if account_from == nil do
        {:error, "Invalid account"}
      else
        {:error, "Invalid amount format"}
      end
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
        generate_transaction(amount, account_from.id, account_to.id, "bank_transfer")
      )
      |> Repo.transaction()

    case db_transaction do
      {:ok, operations} -> {:ok, operations.account_from, operations.transaction}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def bank_transfer_transaction(
        account_from,
        account_to_id,
        amount
      ) do
    account_to = Accounts.get_account!(account_to_id)

    value = StringsHelper.parse_float(amount)

    cond do
      account_from == nil ->
        {:error, "Invalid account"}

      value == nil ->
        {:error, "Invalid amount format"}

      # Verify if user has money
      account_from.id == account_to.id ->
        {:error, "You can't transfer money to your account."}

      Decimal.negative?(value) ->
        {:error, "The amount should be more than zero"}

      BankingHelper.is_negative_balance(account_from.balance, value) ->
        {:error, "You not have money"}

      true ->
        case create_transfer_transaction(account_from, account_to, value) do
          {:ok, account_from, transaction} -> {:ok, account_from, transaction}
          {:error, changeset} -> {:error, changeset}
        end
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
