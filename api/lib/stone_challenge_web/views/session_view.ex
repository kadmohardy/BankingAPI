defmodule StoneChallengeWeb.SessionView do
  use StoneChallengeWeb, :view
  require Logger

  def render("show.json", %{auth_token: auth_token}) do
    %{data: %{token: auth_token.token}}
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
