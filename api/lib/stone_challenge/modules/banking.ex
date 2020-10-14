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

  def register_account(%User{} = user) do
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

  def realize do
    Repo.all(Transaction)
  end

  def register_transaction(
        conn,
        %{
          "amount" => amount,
          "type" => type,
          "target_account_number" => target_account_number
        }
      ) do
    user_id = conn.assigns.signed_user.id

    user = Accounts.get_user_account(user_id)

    if user != nil do
      cond do
        # Verify if user has money
        amount <= 0 ->
          {:error, "The value should be more than zero"}

        user.account.balance < amount ->
          {:error, "You can`t have money"}

        # Do bank draft
        type == 1 ->
          case bank_draft(user.account, amount) do
            {:ok, _} ->
              create_transaction(%{
                amount: amount,
                type: type,
                target_account_number: user.account.account_number,
                user_id: user.id
              })
          end

        # Do bank transfer
        type == 2 ->
          target_account = get_account_by(account_number: target_account_number)

          case bank_transfer(user.account, target_account, amount) do
            {:ok, _} ->
              create_transaction(%{
                amount: amount,
                type: type,
                target_account_number: target_account_number,
                user_id: user.id
              })
          end
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

  defp bank_transfer(%Account{} = user_account, %Account{} = target_account, amount) do
    Repo.transaction(fn ->
      user_account
      |> Account.update_changeset(%{balance: user_account.balance - amount})
      |> Repo.update!()

      target_account
      |> Account.update_changeset(%{balance: target_account.balance + amount})
      |> Repo.update!()
    end)
  end

  defp bank_draft(%Account{} = user_account, amount) do
    Repo.transaction(fn ->
      user_account
      |> Account.update_changeset(%{balance: user_account.balance - amount})
      |> Repo.update!()
    end)
  end

  defp create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end


  def bank_draft_transaction(
        conn,
        %{
          "amount" => amount,
        }
      ) do
    user = Accounts.get_user!(conn.assigns.signed_user.id)

    if user != nil do
      cond do
        # Verify if user has money
        amount <= 0 ->
          {:error, "The value should be more than zero"}

        user.account.balance < amount ->
          {:error, "You can`t have money"}

        case bank_draft(user.account, amount) do
          {:ok, _} ->
            create_transaction(%{
              account_from: user.account.id,
              account_to: user.account.id,
              type: "bank_draft",
              amount: amount,
            })
        end
      end
    else
      {:error, "Invalid account"}
    end
  end
end
