defmodule StoneChallengeWeb.Plugs.Authenticate do
  @moduledoc """
  This module describe authenticate plug
  """
  import Plug.Conn

  alias StoneChallenge.Services.Authenticator
  alias StoneChallenge.Tokens
  require Logger

  def init(opts), do: opts

  def call(conn, _default) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Tokens.get_token_by(%{token: token, revoked: false}) do
          nil -> unauthorized(conn)
          auth_token -> authorized(conn, auth_token.user)
        end

      _ ->
        {:error, "User not authorized"}
    end
  end

  defp authorized(conn, user) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    Logger.debug("NAO AUTORIZADO #$@#$@#$@#$@#$@#$@#$@#$@#$")
    conn |> put_resp_content_type("application/json") |> send_resp(401, "Unauthorized") |> halt()
  end
end
