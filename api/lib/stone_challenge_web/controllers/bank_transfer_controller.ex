defmodule StoneChallengeWeb.BankTransferController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger
  plug :validate_permission when action in [:create]
  plug :validate_parameters when action in [:create]

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
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "Unauthorized")
      |> halt
    end
  end

  def validate_parameters(conn, _) do
    amount = conn.params["amount"]
    account_to = conn.params["account_to"]

    conn

    if amount != nil && account_to != nil do
      conn
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json",
        message: "amount and account_to should be provided"
      )
      |> halt
    end
  end
end
