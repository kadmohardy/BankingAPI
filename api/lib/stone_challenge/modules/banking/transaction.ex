defmodule StoneChallenge.Banking.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :type, :integer
    field :target_account_number, :string

    belongs_to :user, StoneChallenge.Accounts.User

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:amount, :type, :target_account_number, :user_id])
    |> validate_required([:amount, :type, :target_account_number, :user_id])
    |> validate_inclusion(:type, 1..2)
  end
end
