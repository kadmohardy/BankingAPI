defmodule StoneChallengeWeb.BankDraftController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController

  require Logger
  plug :validate_permission when action in [:create]

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
