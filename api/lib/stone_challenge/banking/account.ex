defmodule StoneChallenge.Banking.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :account_number, :string
    field :balance, :integer
    field :user_id, :id
    # belongs_to :user, StoneChallenge.Accounts.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:account_number])
    |> validate_required([:account_number])
    |> unique_constraint([:account_number])
  end

  def update_changeset(account, params \\ %{}) do
    account
    |> cast(params, [:balance])
  end
end
