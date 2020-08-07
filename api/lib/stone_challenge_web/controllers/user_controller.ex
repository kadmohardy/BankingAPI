defmodule StoneChallengeWeb.UserController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Accounts
  alias StoneChallenge.Accounts.User
  alias StoneChallenge.Helper.BankingHelper
  alias StoneChallenge.Banking

  plug(:authenticate when action in [:index, :show])

  def show(conn, _params) do
    user = Accounts.get_user("1")

    conn
    |> render(StoneChallengeWeb.UserView, "show.json", user: user)
  end

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> render(StoneChallengeWeb.UserView, "index.json", users: users)
  end

  def create(conn, params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        account_number = BankingHelper.generate_account_number(user.id)

        account_params = %{code: account_number, user_id: user.id}

        case Banking.register_account(account_params) do
          {:ok, _account} ->
            conn
            |> StoneChallengeWeb.Auth.login(user)
            |> render(StoneChallengeWeb.UserView, "create.json", user: user)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> render(StoneChallengeWeb.ErrorView, "401.json", message: changeset)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json", message: changeset)
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.curret_user do
      conn
    else
      IO.puts("Testando")

      conn
      |> halt()
    end
  end
end
