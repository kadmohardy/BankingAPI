defmodule StoneChallengeWeb.UserController do
  use StoneChallengeWeb, :controller
  require Logger
  alias StoneChallenge.Accounts

  action_fallback StoneChallengeWeb.FallbackController
  plug :validate_permission when action in [:index, :show]

  def index(conn, _params) do
    with users <- Accounts.list_customer_users() do
      conn
      |> render(StoneChallengeWeb.UserView, "index.json", users: users)
    end
  end

  def create(conn, params) do
    with {:ok, user, account} <- Accounts.sign_up(params) do
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

  def validate_permission(conn, _) do
    role = conn.assigns.signed_user.role

    if role == "admin" do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, "Unauthorized")
      |> halt()
    end
  end
end
