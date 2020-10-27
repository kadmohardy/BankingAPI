defmodule StoneChallengeWeb.BankDraftViewTest do
  use StoneChallengeWeb.ConnCase, async: true
  import Phoenix.View
  require Logger
  alias StoneChallenge.Banking.Transaction

  test "renders bank_draft.json", %{conn: conn} do
    account = %StoneChallenge.Accounts.Account{
      id: "5cd95c73-f522-4bd9-935c-70643052cd88",
      balance: 987.50
    }

    transaction = %Transaction{
      id: "dc198650-4a44-41e6-ad92-e7b42ab9dead",
      amount: 12.50,
      account_from: "0d5c0fa7-657e-4b20-a246-3cbdfdc6fd4a",
      account_to: nil,
      type: "bank_draft",
      date: "2020-10-15"
    }

    rendered_bank_draft =
      render(
        StoneChallengeWeb.BankDraftView,
        "bank_draft.json",
        conn: conn,
        account: account,
        transaction: transaction
      )

    body = rendered_bank_draft.data

    assert body.account.account_id == account.id
    assert body.account.balance == account.balance

    assert body.transaction.account_from == transaction.account_from
    assert body.transaction.account_to == transaction.account_to
    assert body.transaction.amount == transaction.amount
    assert body.transaction.date == transaction.date
    assert body.transaction.type == transaction.type
  end
end
