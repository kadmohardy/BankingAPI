defmodule StoneChallenge.AccountsTest do
  use StoneChallenge.DataCase, async: true

  alias StoneChallenge.Accounts
  require Logger

  describe "sign_up/1" do
    @valid_attrs %{
      first_name: "Customer",
      last_name: "Test",
      email: "customertest@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      role: "customer"
    }

    @invalid_attrs %{}

    test "testing user registration with valid data" do
      assert {:ok, user, account} = Accounts.sign_up(@valid_attrs)

      assert user.first_name == "Customer"
      assert user.last_name == "Test"
      assert user.email == "customertest@gmail.com"
      assert user.role == "customer"
      assert account.balance == 1000
    end

    test "testing user registration with invalid data" do
      assert {:error, _changeset} = Accounts.sign_up(@invalid_attrs)
      assert Accounts.list_customer_users() == []
    end

    test "ensure unique email" do
      assert {:ok, user, account} = Accounts.sign_up(@valid_attrs)

      assert {:error, changeset} = Accounts.sign_up(@valid_attrs)

      assert %{email: ["This mail address already used by an user"]} = errors_on(changeset)
    end

    test "verify valid email format" do
      attrs = Map.put(@valid_attrs, :email, "usertest")
      {:error, changeset} = Accounts.sign_up(attrs)

      assert %{email: ["Invalid mail format"]} = errors_on(changeset)
      assert Accounts.list_customer_users() == []
    end

    test "invalid password size" do
      Logger.debug("testing")

      attrs = Map.put(@valid_attrs, :password, "12345")
      {:error, changeset} = Accounts.sign_up(attrs)

      assert %{password: ["Password should be at least 6 character(s)"]} = errors_on(changeset)
      assert Accounts.list_customer_users() == []
    end

    test "different password and confirmation password" do
      Logger.debug("testing")

      attrs = Map.put(@valid_attrs, :password_confirmation, "12345")
      {:error, changeset} = Accounts.sign_up(attrs)

      assert %{password_confirmation: ["Passwords are different"]} = errors_on(changeset)
      assert Accounts.list_customer_users() == []
    end
  end

  describe "sign_in/2" do
    @pass "123456"
    @bad_pass "12345"
    @unknow_user "customer@gmail.com"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "get user with correct password", %{user: user} do
      assert {:ok, auth_token} = Accounts.sign_in(user.email, @pass)
      assert String.length(auth_token.token) > 0
    end

    test "get not autorized user due invalid password", %{user: user} do
      assert {:error, "Incorrects email/password"} = Accounts.sign_in(user.email, @bad_pass)
    end

    test "user account not exist" do
      assert {:error, "User not have account"} = Accounts.sign_in(@unknow_user, @pass)
    end
  end
end
