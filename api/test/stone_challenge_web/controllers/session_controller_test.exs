defmodule StoneChallengeWeb.UserControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true

  require Logger

  describe "testing session with valid user" do
    @create_session_valid_attrs %{email: "customertest1@gmail.com", password: "123456"}
    @create_session_invalid_attrs %{email: "invaliduser@gmail.com", password: "123456"}

    setup %{conn: conn} do
      user = user_fixture()

      {:ok, conn: conn, user: user}
    end

    test "testing create session with valid user", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_valid_attrs)

      body = api_conn |> response(200) |> Poison.decode!()
      assert String.length(body["data"]["token"]) > 0
    end

    test "testing create session with invalid user", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_invalid_attrs)

      body = api_conn |> response(422) |> Poison.decode!()
      assert body["message"] == "User not have account"
    end
  end
end
