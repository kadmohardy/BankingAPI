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
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "Unauthorized")
      |> halt
    end
  end

  #  def validate_parameters(conn, _) do
  #   day = conn.params["day"]
  #   month = conn.params["month"]
  #   year = conn.params["year"]

  #   cond do
  #     day != nil && month != nil && year != nil ->
  #       conn

  #     day != nil && month != nil && year != nil ->
  #         conn
  #   end

  #   if email != nil && password != nil do
  #     conn
  #   else
  #     conn
  #     |> put_status(:unprocessable_entity)
  #     |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "email and password should be provided")
  #     |> halt
  #   end
  # end
end
