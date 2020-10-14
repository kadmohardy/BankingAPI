defmodule StoneChallengeWeb.ReportsController do
  use StoneChallengeWeb, :controller
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  alias StoneChallenge.BackOffice

  def index(conn, params) do
    with {:ok, total} <- BackOffice.transactions_report(conn, params) do
      conn
        |> render(StoneChallengeWeb.ReportsView, "show.json", total: total)
    end
  end
end
