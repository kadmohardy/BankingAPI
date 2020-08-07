defmodule StoneChallenge.Banking do
  @moduledoc """
  This module handle Accounts context
  """
  alias StoneChallenge.Repo
  alias StoneChallenge.Banking.Account
  alias StoneChallenge.Banking.Transaction
  alias StoneChallenge.Banking.TransactionType

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

  def register_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
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

  def register_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_transaction_type(description) do
    Repo.insert!(%TransactionType{description: description}, on_conflict: :nothing)
  end
end
