defmodule StoneChallengeWeb.UserController do
  use StoneChallengeWeb, :controller
  require Logger
  alias StoneChallenge.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> render(StoneChallengeWeb.UserView, "index.json", users: users)
  end

  def create(conn, params) do
    case Accounts.register_user_and_account(params) do
      {:ok, user} ->
        conn
        |> render(StoneChallengeWeb.UserView, "create.json", user: user)

      {:error, _} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json",
          message: "Não foi possível realizar o cadastro. Email já cadastrado."
        )
    end
  end
end
