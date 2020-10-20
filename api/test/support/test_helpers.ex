defmodule StoneChallenge.TestHelpers do
  @moduledoc """
  This module handle tests auxiliary functions
  """
  alias StoneChallenge.{
    Accounts,
    Banking
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user, _account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer",
        last_name: "Test",
        email: "customertest@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    user
  end

  def account_one_fixture(attrs \\ %{}) do
    {:ok, _user, account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer1",
        last_name: "Test1",
        email: "customertest1@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    account
  end

  def account_two_fixture(attrs \\ %{}) do
    {:ok, _user, account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer2",
        last_name: "Test2",
        email: "customertest2@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    account
  end
end
