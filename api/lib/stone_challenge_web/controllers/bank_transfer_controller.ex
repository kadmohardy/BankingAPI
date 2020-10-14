defmodule StoneChallengeWeb.BankTransferController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  def create(
        conn,
        params
      ) do
      with {:ok, transaction} <- Banking.register_transaction(conn, params) do
        Logger.info("TRANSAÇÃO REALIZADA COM SUCESSO #{inspect(transaction)}")

        conn
        |> render("create.json", transaction: transaction)
      end
  end
end
