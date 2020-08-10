defmodule StoneChallengeWeb.ReportsView do
  use StoneChallengeWeb, :view

  def render("show.json", %{total: total}) do
    %{data: total}
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
