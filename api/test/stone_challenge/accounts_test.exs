defmodule StoneChallenge.AccountsTest do
  use StoneChallenge.DataCase, async: true

  alias StoneChallenge.Accounts
  alias StoneChallenge.Accounts.User
  require Logger

  describe "register_user_and_account/1" do
    @valid_attrs %{
      name: "UserTest",
      email: "usertest@gmail.com",
      password: "secret"
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
      Logger.debug("testing")

      attrs = Map.put(@valid_attrs, :password, "12345")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end

  describe "sign_in/2" do
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
