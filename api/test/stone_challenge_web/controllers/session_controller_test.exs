defmodule StoneChallengeWeb.SessionControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true

  require Logger

  describe "testing session with valid user" do
    @create_session_valid_attrs %{email: "customertest@gmail.com", password: "123456"}
    @create_session_invalid_attrs %{email: "invaliduser@gmail.com", password: "123456"}
    @create_session_without_password %{email: "invaliduser@gmail.com"}
    @create_session_without_email %{password: "123456"}
    @create_session_without_attrs %{}

    setup %{conn: conn} do
      user = user_fixture()

      {:ok, conn: conn, user: user}
    end

    test "testing create session with valid user", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_valid_attrs)

      body = api_conn |> response(200) |> Poison.decode!()

      Logger.debug(body["data"]["token"])
      assert String.length(body["data"]["token"]) > 0
    end

    test "testing create session with invalid user", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_invalid_attrs)

      body = api_conn |> response(422) |> Poison.decode!()
      assert body["error"] == "User not have account"
    end

    test "testing create session without password", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_without_password)

      body = api_conn |> response(422) |> Poison.decode!()
      assert body["error"] == "email and password should be provided"
    end

    test "testing create session without email", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_without_email)

      body = api_conn |> response(422) |> Poison.decode!()
      assert body["error"] == "email and password should be provided"
    end

    test "testing create session without attrs", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/sessions", @create_session_without_attrs)

      body = api_conn |> response(422) |> Poison.decode!()
      assert body["error"] == "email and password should be provided"
    end
  end
end
