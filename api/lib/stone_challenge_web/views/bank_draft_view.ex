defmodule StoneChallengeWeb.BankDraftView do
  use StoneChallengeWeb, :view
  require Logger

  def render("bank_draft.json", %{account: account, transaction: transaction}) do
    %{
      data: %{
        account: account_json(account),
        transaction: transaction_json(transaction)
      }
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
      type: transaction.type,
      date: transaction.date
    }
  end
end
