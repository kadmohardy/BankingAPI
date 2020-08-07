defmodule StoneChallengeWeb.PageController do
  use StoneChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
