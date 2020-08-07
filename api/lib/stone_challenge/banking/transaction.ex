defmodule StoneChallenge.Banking.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :transaction_types_id, :integer
    field :user_id, :integer

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:amount, :transaction_types_id, :user_id])
    |> validate_required([:amount, :transaction_types_id, :user_id])
  end
end
