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
    query = from u in User, where: u.customer == true, preload: [:account]

    Repo.all(query)
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
    is_customer = Map.get(attrs, "customer")

    cond do
      is_customer == true ->
        Repo.transaction(fn ->
          user =
            case register_user(attrs) do
              {:ok, user} ->
                user

              {:error, changeset} ->
                Repo.rollback({:user, changeset})
                {:error, :error_in_sign_up}
            end

          case Banking.register_account(user) do
            {:ok, _account} ->
              {:ok, get_user_account(user.id)}

            {:error, changeset} ->
              Repo.rollback({:account, changeset})
              {:error, :error_in_sign_up}
          end
        end)

      true ->
        case register_user(attrs) do
          {:ok, user} -> {:ok, user}
          {:error, _changeset} -> {:error, :error_in_sign_up}
        end
    end
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

  def sign_in(attrs) do
    Logger.info("Testando sign in")

    account_number = Map.get(attrs, "account_number")
    email = Map.get(attrs, "email")
    password = Map.get(attrs, "password")

    user =
      case account_number do
        nil -> get_user_by(%{email: email})
        _ -> get_user_by_account(account_number)
      end

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

  # def get_user_role(conn, params) do
  #   case StoneChallenge.Services.Authenticator.get_auth_token(conn) do
  #     {:ok, token} ->
  #       case StoneChallenge.Tokens.get_token_by(%{token: token, revoked: false}) do
  #         nil -> unauthorized(conn)
  #         auth_token -> authorized(conn, auth_token.user)
  #       end

  #     _ ->
  #       unauthorized(conn)
  #   end
  # end
end
