defmodule StoneChallengeWeb.UserControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  alias StoneChallenge.Tokens
  require Logger

  describe "testing user signup" do
    @create_attrs %{
      first_name: "Create",
      last_name: "Test",
      email: "createtest@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      role: "customer"
    }

    setup %{conn: conn} do
      {:ok, conn: conn}
    end

    test "testing create user", %{conn: conn} do
      api_conn =
        conn
        |> post("/api/users", @create_attrs)

      body = api_conn |> response(201) |> Poison.decode!()

      assert body["user"]["email"] == "createtest@gmail.com"
      assert body["user"]["first_name"] == "Create"
      assert body["user"]["last_name"] == "Test"
      assert body["user"]["role"] == "customer"
    end
  end

  describe "with a logged-in user" do
    @admin_token "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJDE2NDEwNzk0LTU2OTctNGE2YS04NjkwLWI5NWZlMTk4NDUxNmQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhFGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEKZAAGc2Vjb25kYThkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhFGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEKZAAGc2Vjb25kYThkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkZDc5NzZlY2UtYTE0My00ODQ1LWExNmYtN2IxNzFjMjkxZTIwZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABNhZG1pbnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAFQWRtaW5kAAJpZG0AAAAkZDc5NzZlY2UtYTE0My00ODQ1LWExNmYtN2IxNzFjMjkxZTIwZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmEUZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhEGQABW1vbnRoYQpkAAZzZWNvbmRhOGQABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJGN0Zy9VSGlxbnJEQWlWdFdhMTBJVHckNS84VkNnZU1zLmlOVUxCRGw3Vm5uMHBSUktEc3RlZ0VFTVIvZXlTcXdqOVdtMklqdFhDRlkzaW1FLkozRDQ4Q0xNS0FMVWg1WGQyMVZWa2dON0RwSEFkAARyb2xlbQAAAAVhZG1pbmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmEUZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhEGQABW1vbnRoYQpkAAZzZWNvbmRhOGQABHllYXJiAAAH5G4GANga9VF1AWIAAVGA.GZtZb-JBjGfNiiFlywX5SGSBcff3V9OH_rH9kMIh6eM"
    @tag login_as: "admintest@gmail.com"

    setup %{conn: conn, login_as: email} do
      user = user_admin_fixture()
      user_one = account_one_fixture()
      user_two = account_two_fixture()

      {:ok, token} = Tokens.register_token(user, @admin_token)

      conn = assign(conn, :signed_user, user)

      {:ok, user: user, conn: conn}
    end

    test "lists all user's on index with user admin", %{conn: conn} do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @admin_token)
        |> get("/api/users")

      body = api_conn |> response(200) |> Poison.decode!()

      assert length(body["data"]) == 2
    end

    # test "lists all user's on index with user customer", %{conn: conn} do
    #   api_conn =
    #     conn
    #     |> put_req_header("authorization", "Bearer " <> @admin_token)
    #     |> get("/api/users")

    #   body = api_conn |> response(200) |> Poison.decode!

    #   assert length(body["data"]) == 2
    # end
  end
end
