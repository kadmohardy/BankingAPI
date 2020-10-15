defmodule StoneChallengeWeb.BankTransferView do
  use StoneChallengeWeb, :view
  require Logger

  def render("bank_transfer.json", %{account: account, transaction: transaction}) do
    %{
      account: account_json(account),
      transaction: transaction_json(transaction)
    }
  end

  def account_json(account) do
    %{
      account_id: account.id,
      balance: account.balance
    }
  end

  def transaction_json(transaction) do
    %{
      account_from: transaction.account_from,
      account_to: transaction.account_to,
      amount: transaction.amount,
      type: transaction.type
    }
  end
end
