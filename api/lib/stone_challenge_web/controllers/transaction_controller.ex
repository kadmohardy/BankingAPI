defmodule StoneChallengeWeb.TransactionController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking
  alias StoneChallenge.Banking.Transaction
  require Logger
  # plug(:authenticate when action in [:index, :show])

  def show(conn, _params) do
    transaction = Banking.get_transaction("1")

    conn
    |> render(StoneChallengeWeb.TransactionView, "show.json", transaction: transaction)
  end

  def index(conn, _params) do
    transactions = Banking.list_transactions()

    conn
    |> render(StoneChallengeWeb.TransactionView, "index.json", transactions: transactions)
  end

  def create(
        conn,
        params
      ) do
    case Banking.register_transaction(params) do
      {:ok, transaction} ->
        Logger.info("Transaçao realizada com sucesso: #{inspect(transaction)}")

        conn
        |> render(StoneChallengeWeb.TransactionView, "create.json", transaction: transaction)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json", message: changeset)
    end
  end
end
