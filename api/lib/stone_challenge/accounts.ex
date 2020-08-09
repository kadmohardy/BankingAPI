defmodule StoneChallenge.Accounts do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query
  alias StoneChallenge.Repo
  alias StoneChallenge.Accounts.User
  alias StoneChallenge.Banking

  require Logger

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def register_user_and_account(attrs \\ %{}) do
    Repo.transaction(fn ->
      user =
        case register_user(attrs) do
          {:ok, user} -> user
          {:error, changeset} -> Repo.rollback({:user, changeset})
        end

      case Banking.register_account(user) do
        {:ok, _account} ->
          get_user_account(user.id)

        {:error, changeset} ->
          Repo.rollback({:account, changeset})
      end
    end)
  end

  def get_user_account(id) do
    query =
      from u in User,
        where: u.id == ^id,
        preload: [:account]

    Repo.one(query)
  end

  def authenticate_by_account_number_and_password(account_number, password) do
    # user = get_user_by(account_code: account_code)

    # account = Banking.get_account_by(account_number: account_number)
    account = Banking.get_user_account!(account_number: account_number)
    IO.puts(account.account_number)
    {:ok, account}
    # cond do
    #   user && Pbkdf2.verify_pass(password, user.password_hash) ->
    #     {:ok, user}

    #   user ->
    #     {:error, :unauthorized}

    #   true ->
    #     Pbkdf2.no_user_verify()
    #     {:error, :not_found}
    # end
  end
end
