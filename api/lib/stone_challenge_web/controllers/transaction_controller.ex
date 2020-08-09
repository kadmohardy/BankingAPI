defmodule StoneChallengeWeb.TransactionController do
  use StoneChallengeWeb, :controller

  alias StoneChallenge.Banking

  require Logger
  # plug(:authenticate when action in [:index, :show])

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

      {:error, :user_not_registered} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json", message: "Usuário não cadastrado")

      {:error, :not_have_money} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json", message: "Saldo indisponível")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(StoneChallengeWeb.ErrorView, "401.json", message: changeset)
    end
  end
end
