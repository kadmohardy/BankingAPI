defmodule StoneChallenge.BankingTest do
  use StoneChallenge.DataCase, async: true

  alias StoneChallenge.Banking
  alias StoneChallenge.Banking.Transaction

  describe "register_transaction/1" do
    @valid_attrs %{
      amount: "UserTes",
      type: "usertest@gmail.com",
      target_account_number: "secret",
      user_id: 1
    }

    @invalid_attrs %{}

    test "testando cadastro de usuarioo com dados validos" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "UserTest"
      assert user.email == "usertest@gmail.com"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "testando cadastro de usuarioo com dados invalidos" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "garantir email unico" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{email: ["has already been taken"]} = errors_on(changeset)

      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "verifica se email tem o formato válido" do
      attrs = Map.put(@valid_attrs, :email, "usertest")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{email: ["has invalid format"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requer um password com tamanho maior que 6 digitos " do
      attrs = Map.put(@valid_attrs, :password, "12345")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "123456"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_username_and_pass(user.username, @pass)

      assert auth_user.id == user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_username_and_pass(user.username, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_username_and_pass("unknownuser", @pass)
    end
  end
end
