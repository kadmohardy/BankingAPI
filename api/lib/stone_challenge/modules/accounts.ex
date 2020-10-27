defmodule StoneChallenge.Accounts do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query

  alias StoneChallenge.Accounts.{Account, User}
  alias StoneChallenge.Repo
  alias StoneChallenge.Services.Authenticator
  alias StoneChallenge.Tokens
  require Logger

  defp generate_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end

  defp insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
  end

  def get_account(id), do: Repo.get(Account, id)

  def get_account!(id) do
    Repo.get(Account, id) |> Repo.preload(:user)
  rescue
    Ecto.Query.CastError -> :invalid_uuid
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id) do
    Repo.get(User, id) |> Repo.preload(:accounts)
  end

  def get_users do
    Repo.all(User) |> Repo.preload(:accounts)
  end

  def get_user_by(params) do
    Repo.get_by(User, params) |> Repo.preload(:accounts)
  end

  def list_customer_users do
    Repo.all(from u in User, where: u.role == "customer", preload: [:accounts])
  end

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
    role = attrs["role"] || attrs.role

    cond do
      role == "customer" ->
        register_customer(attrs)

      role == "admin" ->
        register_admin(attrs)

      true ->
        {:error, "role should be provided"}
    end
  end

  defp register_customer(attrs \\ %{}) do
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

  defp register_admin(attrs \\ %{}) do
    case insert_user(attrs) do
      {:ok, user} -> {:ok, user, nil}
      {:error, changeset} -> {:error, changeset}
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
