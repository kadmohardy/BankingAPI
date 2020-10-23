defmodule StoneChallengeWeb.ReportsControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  require Logger

  describe "with a logged-in user" do
    @token "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJGJjYWE0MDNiLWNhNDktNDdjYy1hMmU1LWU1OTk0MTg4NzExM2QAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhEWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQ5kAAVtb250aGEKZAAGc2Vjb25kYSxkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhEWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQ5kAAVtb250aGEKZAAGc2Vjb25kYSxkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkZDFjYWI5YzgtNDA5My00MjBlLWI3YWUtOTE5YjY3MmE1ZDYwZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABNhZG1pbnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAFQWRtaW5kAAJpZG0AAAAkZDFjYWI5YzgtNDA5My00MjBlLWI3YWUtOTE5YjY3MmE1ZDYwZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmERZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhDmQABW1vbnRoYQpkAAZzZWNvbmRhK2QABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJG1WZ0FFbGwvNGFBNnlBRzdRNkY0VHckVlpWcDFTaHVOcm9BWlplVjFNNnlxSXNSeXQzTWJoYWY3ZkI4Z2x5TC5ZcTE2MU45ckZSeE54T1BIYXV6SWhiQmZjeG9iUWlOclRTNkRqaVIvVFYxV2dkAARyb2xlbQAAAAVhZG1pbmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmERZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhDmQABW1vbnRoYQpkAAZzZWNvbmRhK2QABHllYXJiAAAH5G4GAEFITlF1AWIAAVGA.o5uONgfBjs_nw0E8JJWuaCt-JJTEd6fR5YaoO3Ra268"
    @tag login_as: "admintest@gmail.com"

    setup %{conn: conn, login_as: email} do
      user = user_admin_fixture(email: email)
      conn = assign(conn, :current_user, user)

      {:ok, user: user, conn: conn}
    end

    test "lists all user's on index", %{user: user, conn: conn} do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @token)
        |> get("/api/users")
    end
  end

  describe "testing user signup" do
    @create_attrs %{
      first_name: "Create",
      last_name: "Test",
      email: "createtest@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      role: "admin"
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
      assert body["user"]["role"] == "admin"
    end
  end
end
