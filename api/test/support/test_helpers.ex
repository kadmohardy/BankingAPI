defmodule StoneChallenge.TestHelpers do
  @moduledoc """
  This module handle tests auxiliary functions
  """
  alias StoneChallenge.{
    Accounts,
    Banking
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
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

  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        type: "bank_draft",
        amount: 50.00,
        account_to: "44b48b28-a736-490d-a73c-3c156e20cfb4",
        account_from: "44b48b28-a736-490d-a73c-3c156e20cfb4",
        type: "transfer"
      })
      |> Banking.create_transfer_transaction()
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
