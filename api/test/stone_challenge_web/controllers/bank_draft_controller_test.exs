defmodule StoneChallengeWeb.BankDraftControllerTest do
  @moduledoc """
  This module describe bank draft controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  alias StoneChallenge.Tokens
  require Logger

  describe "testing bank draft feature" do
    @user_customer_token "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJDdmYzBiYTRmLWYzNjgtNDhjYi1iNTVhLWY0YTRiODI5NjIzMWQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhGmQABGhvdXJhEGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYTtkAAVtb250aGEKZAAGc2Vjb25kYRtkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhGmQABGhvdXJhEGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYTtkAAVtb250aGEKZAAGc2Vjb25kYRtkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkZGIyZjU1NzMtYWU4Mi00MGI3LTgwZmEtNzNkOTY2ZDZlNDJmZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABZjdXN0b21lcnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAIQ3VzdG9tZXJkAAJpZG0AAAAkZGIyZjU1NzMtYWU4Mi00MGI3LTgwZmEtNzNkOTY2ZDZlNDJmZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEaZAAEaG91cmEQZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhO2QABW1vbnRoYQpkAAZzZWNvbmRhG2QABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJDNtRmVmN1lUREV0aVhRS3c1cGtOWkEkUW9pT1VnTU01RmVEZWN4RW5PdnV6OC5PQ0hVTDB1TFY1Z0dKNkV2MXhWdWhvZGc2UTJNTUo1Tm5KN3lka3FicGpRQnhDZy9WcmE0V3ppV2d2c2I4dGdkAARyb2xlbQAAAAhjdXN0b21lcmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEaZAAEaG91cmEQZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhO2QABW1vbnRoYQpkAAZzZWNvbmRhG2QABHllYXJiAAAH5G4GAP292WV1AWIATxoA.2LmL5QD4qthR1gAPqLgFz_HEiHgxBdinXlEytxHySvU"
    @create_attrs %{
      amount: "10.50"
    }

    @create_insufficient_balance_attrs %{
      amount: "2010.50"
    }

    @create_negative_amount_attrs %{
      amount: "-200.50"
    }

    @create_without_amount %{}

    setup %{conn: conn} do
      user = user_fixture()
      conn = assign(conn, :signed_user, user)

      {:ok, token} = Tokens.register_token(user, @user_customer_token)

      {:ok, user: user, conn: conn}
    end

    test "testing bank draft transaction with customer valid user", %{user: user, conn: conn} do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/draft", @create_attrs)

      body = api_conn |> response(200) |> Poison.decode!()

      response = body["data"]
      assert response["account"]["balance"] == "989.50"
      assert response["transaction"]["account_to"] == nil
      assert response["transaction"]["amount"] == "10.5"
      assert response["transaction"]["type"] == "bank_draft"
    end

    test "testing bank draft transaction with customer valid user and invalid amount", %{
      user: user,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/draft", @create_insufficient_balance_attrs)

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["error"] == "You not have money"
    end

    test "testing bank draft transaction with customer valid user and negative amount", %{
      user: user,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/draft", @create_negative_amount_attrs)

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["error"] == "Invalid amount format"
    end

    test "testing bank draft transaction with customer valid user and no providing amount", %{
      user: user,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/draft", @create_without_amount)

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["error"] == "amount should be provided"
    end
  end
end
