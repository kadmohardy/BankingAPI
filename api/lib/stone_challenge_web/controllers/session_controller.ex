defmodule StoneChallengeWeb.SessionController do
  use StoneChallengeWeb, :controller
  require Logger

  action_fallback StoneChallengeWeb.FallbackController
  plug :validate_parameters when action in [:create]

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

  def validate_parameters(conn, _) do
    email = conn.params["email"]
    password = conn.params["password"]

    if email != nil && password != nil do
      conn
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(StoneChallengeWeb.ErrorView, "error_message.json", message: "email and password should be provided")
      |> halt
    end
  end
end
