defmodule StoneChallengeWeb.BankDraftController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  action_fallback StoneChallengeWeb.FallbackController
  plug :validate_parameters when action in [:create]
  plug :validate_permission when action in [:create]

  def create(
        conn,
        %{"amount" => amount}
      ) do
    account_from = conn.assigns.signed_user.accounts

    with {:ok, account, transaction} <- Banking.bank_draft_transaction(account_from, amount) do
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
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "Unauthorized")
      |> halt
    end
  end

  def validate_parameters(conn, _) do
    amount = conn.params["amount"]

    if amount != nil do
      conn
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "amount should be provided")
      |> halt
    end
  end
end
