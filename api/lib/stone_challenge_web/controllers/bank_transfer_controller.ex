defmodule StoneChallengeWeb.BankTransferController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger
  plug :validate_permission when action in [:create]

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
        StoneChallengeWeb.BankTransferView,
        "bank_transfer.json",
        %{account: account, transaction: transaction}
      )
    end
  end

  def validate_permission(conn, _) do
    role = conn.assigns.signed_user.role

    if role == "customer" do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, "Unauthorized")
      |> halt()
    end
  end
end
