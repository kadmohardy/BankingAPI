defmodule StoneChallengeWeb.BankDraftController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  def create(
        conn,
        %{"amount" => amount}
      ) do
    account_from = conn.assigns.signed_user.accounts

    with {:ok, account, transaction} <- Banking.bank_draft_transaction(account_from, amount) do
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
