defmodule StoneChallengeWeb.BankDraftController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  def create(
        conn,
        params
      ) do
    with {:ok, account, transaction} <- Banking.bank_draft_transaction(conn, params) do
      Logger.info("TRANSAÇÃO REALIZADA COM SUCESSO #{inspect(account)}")

      conn
      |> render(
        StoneChallengeWeb.BankDraftView,
        "bank_draft.json",
        %{account: account, transaction: transaction}
      )
    end
  end
end
