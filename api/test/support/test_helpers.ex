defmodule StoneChallenge.TestHelpers do
  alias StoneChallenge.{
    Accounts,
    Banking
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "UserTest",
        email: "usertest@gmail.com",
        password: attrs[:password] || "123456"
      })
      |> Accounts.register_user_and_account()

    user
  end

  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 1000,
        type: 1,
        user_id: 1,
        target_account_number: "197008"
      })
      |> Banking.register_transaction()

    transaction
  end

  # def auth_token_fixture(attrs \\ %{}) do
  #   {:ok, auth_token} =
  #     attrs
  #     |> Enum.into(%{
  #       token: "Some Token",
  #       revoked: false,
  #       user_id: 29
  #     })
  #     |> AuthToken.register_user()

  #   auth_token
  # end
end
