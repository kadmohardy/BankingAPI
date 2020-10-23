defmodule StoneChallenge.TestHelpers do
  @moduledoc """
  This module handle tests auxiliary functions
  """
  alias StoneChallenge.{
    Accounts,
    Banking
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user, _account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer",
        last_name: "Test",
        email: "customertest@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    user
  end

  def user_admin_fixture(attrs \\ %{}) do
    {:ok, user, _account} =
      attrs
      |> Enum.into(%{
        first_name: "Admin",
        last_name: "Test",
        email: "admintest@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "admin"
      })
      |> Accounts.sign_up()

    user
  end

  def account_one_fixture(attrs \\ %{}) do
    {:ok, user, account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer1",
        last_name: "Test1",
        email: "customertest1@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    {user, account}
  end

  def account_two_fixture(attrs \\ %{}) do
    {:ok, _user, account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer2",
        last_name: "Test2",
        email: "customertest2@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    account
  end

  def user_three_fixture(attrs \\ %{}) do
    {:ok, user, _account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer3",
        last_name: "Test3",
        email: "customertest3@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    user
  end

  def user_four_fixture(attrs \\ %{}) do
    {:ok, user, _account} =
      attrs
      |> Enum.into(%{
        first_name: "Customer4",
        last_name: "Test4",
        email: "customertest4@gmail.com",
        password: attrs[:password] || "123456",
        password_confirmation: attrs[:password_confirmation] || "123456",
        role: "customer"
      })
      |> Accounts.sign_up()

    user
  end

  def admin_token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        token:
          "SFMyNTY.g2gDdAAAAA5kAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACGFjY291bnRzdAAAAAhkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQABnNvdXJjZW0AAAAIYWNjb3VudHNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACZFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuQWNjb3VudGQAB2JhbGFuY2V0AAAABGQACl9fc3RydWN0X19kAA5FbGl4aXIuRGVjaW1hbGQABGNvZWZiAAGGoGQAA2V4cGL____-ZAAEc2lnbmEBZAACaWRtAAAAJDE2NDEwNzk0LTU2OTctNGE2YS04NjkwLWI5NWZlMTk4NDUxNmQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhFGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEKZAAGc2Vjb25kYThkAAR5ZWFyYgAAB-RkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhFGQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEKZAAGc2Vjb25kYThkAAR5ZWFyYgAAB-RkAAR1c2VydAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAANvbmVkAAlfX2ZpZWxkX19kAAR1c2VyZAAJX19vd25lcl9fZAAmRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkFjY291bnRzLkFjY291bnRkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAHdXNlcl9pZG0AAAAkZDc5NzZlY2UtYTE0My00ODQ1LWExNmYtN2IxNzFjMjkxZTIwZAALYXV0aF90b2tlbnN0AAAABGQAD19fY2FyZGluYWxpdHlfX2QABG1hbnlkAAlfX2ZpZWxkX19kAAthdXRoX3Rva2Vuc2QACV9fb3duZXJfX2QAI0VsaXhpci5TdG9uZUNoYWxsZW5nZS5BY2NvdW50cy5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABNhZG1pbnRlc3RAZ21haWwuY29tZAAKZmlyc3RfbmFtZW0AAAAFQWRtaW5kAAJpZG0AAAAkZDc5NzZlY2UtYTE0My00ODQ1LWExNmYtN2IxNzFjMjkxZTIwZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmEUZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhEGQABW1vbnRoYQpkAAZzZWNvbmRhOGQABHllYXJiAAAH5GQACWxhc3RfbmFtZW0AAAAEVGVzdGQACHBhc3N3b3JkZAADbmlsZAAVcGFzc3dvcmRfY29uZmlybWF0aW9uZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJGN0Zy9VSGlxbnJEQWlWdFdhMTBJVHckNS84VkNnZU1zLmlOVUxCRGw3Vm5uMHBSUktEc3RlZ0VFTVIvZXlTcXdqOVdtMklqdFhDRlkzaW1FLkozRDQ4Q0xNS0FMVWg1WGQyMVZWa2dON0RwSEFkAARyb2xlbQAAAAVhZG1pbmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEWZAAEaG91cmEUZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhEGQABW1vbnRoYQpkAAZzZWNvbmRhOGQABHllYXJiAAAH5G4GANga9VF1AWIAAVGA.GZtZb-JBjGfNiiFlywX5SGSBcff3V9OH_rH9kMIh6eM"
      })
      |> Tokens.register_token()

    token
  end

  def bank_draft_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 12.50
      })
      |> Banking.bank_draft_transaction()

    transaction
  end

  def bank_transfer_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 12.50
      })
      |> Banking.bank_transfer_transaction()

    transaction
  end
end
