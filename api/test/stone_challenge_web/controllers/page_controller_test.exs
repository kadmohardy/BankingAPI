defmodule StoneChallengeWeb.PageControllerTest do
  @moduledoc """
  This module describe page controller test
  """
  use StoneChallengeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Stone Challenge API!"
  end
end
