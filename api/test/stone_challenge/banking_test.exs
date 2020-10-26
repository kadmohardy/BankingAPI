defmodule StoneChallenge.BankingTest do
  use StoneChallenge.DataCase, async: true

  alias StoneChallenge.Banking
  require Logger

  describe "bank_draft_transaction/2" do
    @invalid_attrs %{}
    @pass "123456"

    setup do
      {user, account} = account_one_fixture(password: @pass)

      {:ok, account: account}
    end

    test "bank draft transaction", %{account: account} do
      {:ok, account, transaction} = Banking.bank_draft_transaction(account, "10.45")

      assert account.balance == Decimal.new(989.55)
      assert transaction.account_to == nil
      assert transaction.type == "bank_draft"
    end

    test "bank draft transaction with negative amount", %{account: account} do
      assert {:error, "Invalid amount format"} = Banking.bank_draft_transaction(account, "-10.45")
    end

    test "bank draft transaction with insufficient balance", %{account: account} do
      assert {:error, "You not have money"} = Banking.bank_draft_transaction(account, "1210.45")
    end
  end

  describe "bank_transfer_transaction/3" do
    @pass "123456"
    @amount "10.34"
    setup do
      {user_one, account_one} = account_one_fixture(password: @pass)

      {:ok, account_one: account_one}
    end

    test "bank transfer transaction", %{account_one: account_one} do
      account_two = account_two_fixture()

      {:ok, account_from, transaction} =
               Banking.bank_transfer_transaction(account_one, account_two.id, "15.50")

      assert transaction.type == "bank_transfer"
      assert transaction.amount == Decimal.new(15.50)
    end

    test "bank draft transaction with negative amount", %{account_one: account_one} do
      account_two = account_two_fixture()

      assert {:error, "Invalid amount format"} =
               Banking.bank_transfer_transaction(account_one, account_two.id, "-10.45")
    end

    test "bank draft transaction with insufficient balance", %{account_one: account_one} do
      account_two = account_two_fixture()

      assert {:error, "You not have money"} =
               Banking.bank_transfer_transaction(account_one, account_two.id, "1210.45")
    end

    test "bank draft with account_to equals to account_from", %{account_one: account_one} do
      assert {:error, "You can't transfer money to your account."} =
               Banking.bank_transfer_transaction(account_one, account_one.id, "1210.45")
    end
  end
end
