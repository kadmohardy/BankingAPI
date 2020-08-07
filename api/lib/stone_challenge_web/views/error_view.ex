defmodule StoneChallengeWeb.ErrorView do
  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
