defmodule StoneChallenge.Accounts do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query
  alias StoneChallenge.Repo
  alias StoneChallenge.Accounts.User
  alias StoneChallenge.Banking
  alias StoneChallenge.Services.Authenticator
  alias StoneChallenge.Tokens
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

  def get_user_by_account(account_number) do
    query =
      from u in User,
        join: a in assoc(u, :account),
        where: a.account_number == ^account_number,
        preload: [account: a]

    Repo.one(query)
  end

  def sign_in(account_number, password) do
    Logger.info("Testando sign in")
    user = get_user_by_account(account_number)

    cond do
      user && Pbkdf2.verify_pass(password, user.password_hash) ->
        token = Authenticator.generate_token(user)

        case Tokens.register_token(user, token) do
          {:ok, token} -> {:ok, token}
          {:error, _} -> {:error, :token_not_registered}
        end

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        # case Repo.get_by(AuthToken, %{token: token}) do
        case StoneChallenge.Tokens.get_token_by(%{token: token}) do
          nil ->
            {:error, :not_found}

          auth_token ->
            StoneChallenge.Tokens.remove_token(auth_token)
        end

      error ->
        error
    end
  end
end
