defmodule StoneChallenge.Accounts do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query
  alias StoneChallenge.Repo
  alias StoneChallenge.Accounts.{Account, User}
  alias StoneChallenge.Banking
  alias StoneChallenge.Services.Authenticator
  alias StoneChallenge.Tokens
  require Logger

  defp generate_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
  end

  def get_account(id), do: Repo.get(Account, id)

  def get_account!(id) do
    Repo.get(Account, id) |> Repo.preload(:user)
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id) do
    Repo.get(User, id) |> Repo.preload(:accounts)
  end

  def get_users() do
    Repo.all(User) |> Repo.preload(:accounts)
  end

  def get_user_by(params) do
    Repo.get_by(User, params) |> Repo.preload(:accounts)
  end

  def list_customer_users do
    query = from u in User, where: u.role == "customer", preload: [:accounts]

    Repo.all(query)
  end

  # def change_registration(%User{} = user, params) do
  #   User.registration_changeset(user, params)
  # end

  # def register_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.registration_changeset(attrs)
  #   |> Repo.insert()
  # end

  # def get_user_account(id) do
  #   query =
  #     from u in User,
  #       where: u.id == ^id,
  #       preload: [:account]

  #   Repo.one(query)
  # end

  # def get_user_by_account(account_number) do
  #   query =
  #     from u in User,
  #       join: a in assoc(u, :account),
  #       where: a.account_number == ^account_number,
  #       preload: [account: a]

  #   Repo.one(query)
  # end

  def sign_in(email, password) do
    user = get_user_by(%{email: email})

    cond do
      user && Pbkdf2.verify_pass(password, user.password_hash) ->
        token = Authenticator.generate_token(user)

        case Tokens.register_token(user, token) do
          {:ok, token} -> {:ok, token}
          {:error, _} -> {:error, "Error in token registered"}
        end

      user ->
        {:error, "Incorrects email/password"}

      true ->
        Pbkdf2.no_user_verify()
        {:error, "User not have account"}
    end
  end

  def sign_up(attrs \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, generate_user(attrs))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        user
        |> Ecto.build_assoc(:accounts)
        |> Account.changeset()
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, operations} -> {:ok, operations.user, operations.account}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
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
