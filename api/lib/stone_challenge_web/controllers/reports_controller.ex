defmodule StoneChallengeWeb.ReportsController do
  use StoneChallengeWeb, :controller
  require Logger

  alias StoneChallenge.BackOffice

  # plug(:authenticate when action in [:index, :show])

  def index(conn, params) do
    case BackOffice.transactions_report(params) do
      nil ->
        conn
        |> render(StoneChallengeWeb.ReportsView, "401.json",
          message: "Periodo informado inválido."
        )

      total ->
        conn
        |> render(StoneChallengeWeb.ReportsView, "show.json", total: total)
    end
  end
end
