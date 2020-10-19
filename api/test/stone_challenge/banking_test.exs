defmodule StoneChallenge.BankingTest do
  use StoneChallenge.DataCase, async: true

  alias StoneChallenge.Accounts
  alias StoneChallenge.Accounts.User
  require Logger

  describe "sign_in/2" do
    @valid_attrs %{
      amount: 10.00,
      account_from: "Test",
      account_to: "usertest@gmail.com",
      type: "transfer"
    }

    @invalid_attrs %{}
    @pass "123456"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "obtem usuario com senha correta", %{user: user} do
      assert {:ok, auth_token} = Accounts.sign_in(user.account.account_number, @pass)

      assert String.length(auth_token.token) > 0
    end

    test "retorna usuario não autorizado com password invalido", %{user: user} do
      assert {:error, :unauthorized} = Accounts.sign_in(user.account.account_number, "badpass")
    end

    test "retorna nao encontrado para usuario com conta inexistente" do
      assert {:error, :not_found} = Accounts.sign_in("unknownuser", @pass)
    end
  end
end
