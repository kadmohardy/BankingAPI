defmodule StoneChallenge.Banking.TransactionType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction_types" do
    field :description, :string

    timestamps()
  end

  def changeset(transaction_type, params \\ %{}) do
    transaction_type
    |> cast(params, [:transaction_type])
    |> validate_required([:transaction_type])
  end
end
