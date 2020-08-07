defmodule StoneChallengeWeb.SessionView do
  use StoneChallengeWeb, :view

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
