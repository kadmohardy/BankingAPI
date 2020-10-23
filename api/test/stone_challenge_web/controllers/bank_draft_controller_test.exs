defmodule StoneChallengeWeb.BankDraftControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  require Logger

  describe "testing bank draft feature" do
    @create_attrs %{
      amount: 10.50
    }

    setup %{conn: conn, login_as: email} do
      user = user_one_fixture()
      conn = assign(conn, :signed_user, user)

      {:ok, user: user, conn: conn}
    end

    test "testing bank draft transaction", %{user: user, conn: conn} do
      api_conn =
        conn
        |> post("/transactions/draft", @create_attrs)

      body = api_conn |> response(200) |> Poison.decode!

      # Logger.debug("TESTANDO DRAFT CONTROLLER", body)
    end
  end

  # describe "testing user signup" do

  #   setup %{conn: conn} do
  #     {:ok, conn: conn}
  #   end

  #   test "testing create user", %{conn: conn} do
  #     api_conn =
  #       conn
  #       |> post("/api/users", @create_attrs)

  #     body = api_conn |> response(201) |> Poison.decode!

  #     assert body["user"]["email"] == "createtest@gmail.com"
  #     assert body["user"]["first_name"] == "Create"
  #     assert body["user"]["last_name"] == "Test"
  #     assert body["user"]["role"] == "admin"
  #   end
  # end
end
