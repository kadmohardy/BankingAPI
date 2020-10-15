defmodule StoneChallengeWeb.BankTransferController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  def create(
        conn,
        params
      ) do
    with {:ok, account, transaction} <- Banking.bank_transfer_transaction(conn, params) do
      Logger.info("TRANSAÇÃO REALIZADA COM SUCESSO #{inspect(transaction)}")

      conn
      |> render(
        StoneChallengeWeb.BankDraftView,
        "bank_transfer.json",
        %{account: account, transaction: transaction}
      )
    end
  end
end
