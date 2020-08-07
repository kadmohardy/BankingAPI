defmodule StoneChallengeWeb.SessionController do
  use StoneChallengeWeb, :controller

  def create(conn, %{"session" => %{"account_code" => account_code, "password" => password}}) do
    case StoneChallenge.Accounts.authenticate_by_account_code_and_password(account_code, password) do
      {:ok, user} ->
        conn
        |> StoneChallengeWeb.Auth.login(user)

      {:error, :not_found} ->
        conn
        |> put_status(:unauthorized)
        |> render("401.json", message: "Invalid account/password combination")
    end
  end

  def delete(conn, _) do
    conn
    |> StoneChallengeWeb.Auth.logout()
  end
end
