defmodule StoneChallengeWeb.UserView do
  use StoneChallengeWeb, :view
  alias StoneChallenge.Accounts.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def render("show.json", %{user: user}) do
    user_json(user)
  end

  def render("index.json", %{users: users}) do
    Enum.map(users, &user_json/1)
  end

  def render("create.json", %{user: user}) do
    user_json(user)
  end

  def user_json(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
      # inserted_at: user.inserted_at,
      # updated_at: user.updated_at
    }
  end
end
