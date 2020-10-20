defmodule StoneChallengeWeb.BankTransferController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger

  def create(
        conn,
        %{
          "account_to" => account_to_id,
          "amount" => amount
        }
      ) do
    account_from = conn.assigns.signed_user.accounts

    with {:ok, account, transaction} <-
           Banking.bank_transfer_transaction(account_from, account_to_id, amount) do
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
