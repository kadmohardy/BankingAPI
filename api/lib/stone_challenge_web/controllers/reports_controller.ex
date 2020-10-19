defmodule StoneChallengeWeb.ReportsController do
  use StoneChallengeWeb, :controller

  action_fallback StoneChallengeWeb.FallbackController
  alias StoneChallenge.BackOffice

  plug :validate_permission when action in [:index]

  def index(conn, params) do
    with {:ok, total} <- BackOffice.transactions_report(params) do
      conn
      |> render(StoneChallengeWeb.ReportsView, "show.json", total: total)
    end
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
