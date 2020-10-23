defmodule StoneChallengeWeb.ReportsControllerTest do
  @moduledoc """
  This module describe user controller test
  """
  use StoneChallengeWeb.ConnCase, async: true
  alias StoneChallenge.Banking
  alias StoneChallenge.Tokens
  require Logger

  describe "testing reports feature" do
    @token "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJDJiYzE5YjVkLWVlNGQtNDMxNS1iMzhjLWY4MjAzMTFmZmI1MmQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhF2QABGhvdXJhEmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYTZkAAVtb250aGEKZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhF2QABGhvdXJhEmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYTZkAAVtb250aGEKZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkNTM5YmMyMjItNmFiOS00OWI2LWI2YWItYjcwMTYwMjljZmE2ZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABNhZG1pbnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAFQWRtaW5kAAJpZG0AAAAkNTM5YmMyMjItNmFiOS00OWI2LWI2YWItYjcwMTYwMjljZmE2ZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEXZAAEaG91cmESZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhNmQABW1vbnRoYQpkAAZzZWNvbmRhEWQABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJHFSb2hrQVJwZi8uSlJ3bWRUazJjTVEkQWZKRUVLMFh0cEUyVXE4S2gyTWxoQ1dpLmlTVFo1djgvTy5HNnlTWkJXY2JwZ3laVVQ2R0dmT1hmVDhUN3J4SmNBLlNzL0I1Y0hYZlcxbjNiNkFaRmdkAARyb2xlbQAAAAVhZG1pbmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEXZAAEaG91cmESZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhNmQABW1vbnRoYQpkAAZzZWNvbmRhEWQABHllYXJiAAAH5G4GAK_Kz1Z1AWIAAVGA.Bf42uYzBeBVSh4lTkK_1QTFaHuVFh9dtygYDwAxvHXM"
    @tag login_as: "admintest@gmail.com"

    setup %{conn: conn, login_as: email} do
      user = user_admin_fixture(email: email)
      {:ok, token} = Tokens.register_token(user, @token)

      {user_from, account_from} = account_one_fixture()
      account_to = account_two_fixture()

      conn = assign(conn, :current_user, user)

      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(12.50))
      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(2.50))
      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(18.50))
      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(8.00))
      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(4.50))
      Banking.create_transfer_transaction(account_from, account_to, Decimal.from_float(11.50))

      Banking.create_draft_transaction(account_from, Decimal.from_float(5.00))
      Banking.create_draft_transaction(account_from, Decimal.from_float(15.00))
      Banking.create_draft_transaction(account_from, Decimal.from_float(25.00))
      Banking.create_draft_transaction(account_from, Decimal.from_float(45.00))
      Banking.create_draft_transaction(account_from, Decimal.from_float(25.00))
      Banking.create_draft_transaction(account_from, Decimal.from_float(55.00))

      {:ok, conn: conn}
    end

    test "load diary report", %{conn: conn} do
      api_conn =
        conn
        |> put_req_header("authorization", "Bearer " <> @token)
        |> get("/api/reports?day=23&month=10&year=2020")

      body = api_conn |> response(200) |> Poison.decode!()

      assert body["data"]["total"] == "227.50"
    end
  end
end
