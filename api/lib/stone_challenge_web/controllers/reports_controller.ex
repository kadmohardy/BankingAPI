defmodule StoneChallengeWeb.ReportsController do
  use StoneChallengeWeb, :controller
  require Logger

  alias StoneChallenge.BackOffice

  # plug(:authenticate when action in [:index, :show])

  def index(conn, params) do
    case BackOffice.transactions_report(params) do
      {:ok, _} ->
        conn

      {:error, _} ->
        conn
        # Logger.info("Deleting user from the system: #{inspect(params)}")
    end
  end
end
