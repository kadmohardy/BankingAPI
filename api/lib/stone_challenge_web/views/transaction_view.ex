defmodule StoneChallengeWeb.TransactionView do
  use StoneChallengeWeb, :view
  alias StoneChallenge.Helper.BankingHelper

  def render("show.json", %{transaction: transaction}) do
    transaction_json(transaction)
  end

  def render("index.json", %{transactions: transactions}) do
    Enum.map(transactions, &transaction_json/1)
  end

  def render("create.json", %{transaction: transaction}) do
    transaction_json(transaction)
  end

  def transaction_json(transaction) do
    %{
      id: transaction.id,
      amount: transaction.amount,
      target_account_number: transaction.target_account_number,
      type: BankingHelper.get_operation_str(transaction.type),
      inserted_at: transaction.inserted_at,
      updated_at: transaction.updated_at
    }
  end
end
