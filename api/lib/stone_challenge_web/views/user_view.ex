defmodule StoneChallengeWeb.UserView do
  use StoneChallengeWeb, :view
  alias StoneChallenge.Accounts.User
  require Logger

  def render("account.json", %{account: account, user: user}) do
    %{
      data: %{
        account_id: account.id,
        balance: account.balance,
        user: user_json(user)
      }
    }
  end

  def render("user.json", %{user: user}) do
    user_account_json(user)
  end

  def render("user_admin.json", %{user: user}) do
    %{
      data: user_json(user)
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("create.json", %{user: user}) do
    %{
      data: user_json(user)
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role
    }
  end

  def user_account_json(user) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role,
      account: account_json(user.accounts)
    }
  end

  def account_json(account) do
    %{
      account_id: account.id,
      balance: account.balance
    }
  end
end
