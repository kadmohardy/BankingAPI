defmodule StoneChallengeWeb.Plugs.Authenticate do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _default) do
    case StoneChallenge.Services.Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case StoneChallenge.Tokens.get_token_by(%{token: token, revoked: false}) do
          nil -> unauthorized(conn)
          auth_token -> authorized(conn, auth_token.user)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp authorized(conn, user) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    Logger.info("################")
    conn |> send_resp(401, "Unauthorized") |> halt()
  end
end
