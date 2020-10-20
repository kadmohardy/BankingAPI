defmodule StoneChallengeWeb.SessionController do
  use StoneChallengeWeb, :controller
  require Logger

  action_fallback StoneChallengeWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, auth_token} <- StoneChallenge.Accounts.sign_in(email, password) do
      conn
      |> put_status(:ok)
      |> render(StoneChallengeWeb.SessionView, "show.json", auth_token: auth_token)
    end
  end

  def delete(conn, _) do
    case StoneChallenge.Accounts.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "Sign out realized with success.")
    end
  end
end
