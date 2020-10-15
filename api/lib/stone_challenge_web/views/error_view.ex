defmodule StoneChallengeWeb.ErrorView do
  use StoneChallengeWeb, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("error_message.json", %{message: message}) do
    %{message: message}
  end
end
