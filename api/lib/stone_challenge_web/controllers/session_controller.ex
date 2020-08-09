defmodule StoneChallengeWeb.SessionController do
  use StoneChallengeWeb, :controller

  def create(conn, %{"account_number" => account_number, "password" => password}) do
    case StoneChallenge.Accounts.authenticate_by_account_number_and_password(
           account_number,
           password
         ) do
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
