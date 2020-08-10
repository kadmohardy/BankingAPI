defmodule StoneChallengeWeb.SessionController do
  use StoneChallengeWeb, :controller
  require Logger

  def create(conn, %{"account_number" => account_number, "password" => password}) do
    case StoneChallenge.Accounts.sign_in(
           account_number,
           password
         ) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render(StoneChallengeWeb.SessionView, "show.json", auth_token: auth_token)

      {:error, :not_found} ->
        conn
        |> put_status(:unauthorized)
        |> render(StoneChallengeWeb.SessionView, "401.json", message: "Usuário/Senha invalido.")
    end
  end

  def delete(conn, _) do
    case StoneChallenge.Accounts.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "Sign out realizado com sucesso.")
    end
  end
end
