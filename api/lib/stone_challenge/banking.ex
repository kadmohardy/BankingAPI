defmodule StoneChallenge.Banking do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query, warn: false
  require Logger

  alias StoneChallenge.Repo
  alias StoneChallenge.Banking.Account
  alias StoneChallenge.Banking.Transaction
  alias StoneChallenge.Banking.TransactionType
  alias StoneChallenge.Accounts
  alias StoneChallenge.Helper.BankingHelper

  def get_account(id) do
    Repo.get(Account, id)
  end

  def get_account!(id) do
    Repo.get!(Account, id)
  end

  def get_account_by(params) do
    Repo.get_by(Account, params)
  end

  def list_accounts do
    Repo.all(Account)
  end

  def register_account(%Accounts.User{} = user) do
    account_number = BankingHelper.generate_account_number(user.id)
    account_params = %{account_number: account_number, user_id: user.id}

    %Account{}
    |> Account.changeset(account_params)
    |> Repo.insert()
  end

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

  def register_transaction(
        %{
          "user_id" => user_id,
          "amount" => amount,
          "transaction_type_id" => transaction_type_id,
          "target_account_number" => target_account_number
        } = params
      ) do
    user = Accounts.get_user_account(user_id)

    target_account = get_account_by(account_number: target_account_number)

    Logger.info("USUARIO TEM SALDO  ==============: #{inspect(target_account)}")

    if user != nil do
      cond do
        target_account == nil ->
          {:error, :target_account_not_found}

        user.account.balance > amount ->
          case update_user_accounts(user.account, target_account, amount) do
            {:ok, _} ->
              create_transaction(params)
          end

        true ->
          {:error, :not_have_money}
      end
    else
      {:error, :user_not_registered}
    end
  end

  def update_account(%Account{} = account, params) do
    account
    |> Account.changeset(params)
    |> Repo.update!()
  end

  defp update_user_accounts(%Account{} = user_account, %Account{} = target_account, amount) do
    Repo.transaction(fn ->
      user_account
      |> Account.update_changeset(%{balance: user_account.balance - amount})
      |> Repo.update!()

      target_account
      |> Account.update_changeset(%{balance: target_account.balance + amount})
      |> Repo.update!()
    end)
  end

  defp create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
