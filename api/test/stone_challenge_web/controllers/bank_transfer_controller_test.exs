defmodule StoneChallengeWeb.BankTransferControllerTest do
  @moduledoc """
  This module describe bank draft controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  alias StoneChallenge.Tokens
  require Logger

  describe "testing bank transfer feature" do
    @user_customer_token "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJDhmZjM2MzFlLTRkZDYtNGY5Ni1iOGEwLTcyOTAwYjJkNDY3OWQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhF2QABGhvdXJhAmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYThkAAVtb250aGEKZAAGc2Vjb25kYTNkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhF2QABGhvdXJhAmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYThkAAVtb250aGEKZAAGc2Vjb25kYTNkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkMDZlYjUxYzctMzM3ZS00ZjFhLTkxYjgtMGYxZDVjZjhjZTI5ZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABZjdXN0b21lcnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAIQ3VzdG9tZXJkAAJpZG0AAAAkMDZlYjUxYzctMzM3ZS00ZjFhLTkxYjgtMGYxZDVjZjhjZTI5ZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEXZAAEaG91cmECZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhOGQABW1vbnRoYQpkAAZzZWNvbmRhM2QABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJHdmS0JzUXZBVGtUVU5Tb0Y3blRKQnckTzNXSWJRdWJ4V1UyQi5mS29zaDdlcXhZL2NYdFZuOHlGZjhFQ0tZM2JoS3lYSG5MdjFoYW5kdVpFaUtSOGdxTGtGZ1dqM2cycVV5U0Z4bXEyRExiMGdkAARyb2xlbQAAAAhjdXN0b21lcmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEXZAAEaG91cmECZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhOGQABW1vbnRoYQpkAAZzZWNvbmRhM2QABHllYXJiAAAH5G4GABc8Y1N1AWIAAVGA.CxSOnszV-r87-bjX1FQtW8VY71rSXBeotlNqjKvkKKs"

    setup %{conn: conn} do
      {user_from, account_from} = account_one_fixture()
      account_to = account_two_fixture()

      {:ok, token} = Tokens.register_token(user_from, @user_customer_token)

      {:ok, account_from: account_from, account_to: account_to, conn: conn}
    end

    test "testing bank transfer transaction with customer valid user", %{
      account_from: account_from,
      account_to: account_to,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/transfer", %{
          account_to: account_to.id,
          amount: 10.50
        })

      body = api_conn |> response(200) |> Poison.decode!()

      Logger.info("TESTANDO #{inspect(body)}")
      assert body["account"]["balance"] == "989.50"
      assert body["account"]["account_id"] == account_from.id
      assert body["transaction"]["account_from"] == account_from.id
      assert body["transaction"]["account_to"] == account_to.id
      assert body["transaction"]["amount"] == "10.5"
      assert body["transaction"]["type"] == "bank_transfer"
    end

    test "testing bank transfer transaction with customer valid user and invalid amount", %{
      account_to: account_to,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/transfer", %{
          account_to: account_to.id,
          amount: 2010.50
        })

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["message"] == "You not have money"
    end

    test "testing bank transfer transaction with customer valid user and negative amount", %{
      account_to: account_to,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/transfer", %{
          account_to: account_to.id,
          amount: -200.50
        })

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["message"] == "The amount should be more than zero"
    end

    test "testing bank transfer transaction to self account", %{
      account_from: account_from,
      conn: conn
    } do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @user_customer_token)
        |> post("/api/transactions/transfer", %{
          account_to: account_from.id,
          amount: 10.50
        })

      body = api_conn |> response(422) |> Poison.decode!()

      assert body["message"] == "You can't transfer money to your account."
    end
  end
end
