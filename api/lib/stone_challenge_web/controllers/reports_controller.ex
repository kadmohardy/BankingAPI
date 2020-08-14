defmodule StoneChallengeWeb.ReportsController do
  use StoneChallengeWeb, :controller
  require Logger

  alias StoneChallenge.BackOffice

  def index(conn, params) do
    case BackOffice.transactions_report(conn, params) do
      {:error, :user_not_authorized} ->
        conn
        |> render(StoneChallengeWeb.ReportsView, "401.json", message: "Usuário não tem permissão.")

      {:ok, nil} ->
        conn
        |> render(StoneChallengeWeb.ReportsView, "401.json",
          message: "Periodo informado inválido."
        )

      {:ok, total} ->
        conn
        |> render(StoneChallengeWeb.ReportsView, "show.json", total: total)
    end
  end
end
