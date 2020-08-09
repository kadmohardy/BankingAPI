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
    |> cast(params, [:amount, :transaction_type_id, :target_account_number, :user_id])
    |> validate_required([:amount, :transaction_type_id, :user_id])
  end
end
