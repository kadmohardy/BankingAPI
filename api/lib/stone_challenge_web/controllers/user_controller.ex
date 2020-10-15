defmodule StoneChallengeWeb.UserController do
  use StoneChallengeWeb, :controller
  require Logger
  alias StoneChallenge.Accounts

  action_fallback StoneChallengeWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.get_users()

    conn
    |> render(StoneChallengeWeb.UserView, "index.json", users: users)
  end

  def create(conn, params) do
    with {:ok, user, account} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, id: user.id))
      |> render(StoneChallengeWeb.UserView, "account.json", %{account: account, user: user})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    conn
    |> render("show.json", user: user)
  end
end
