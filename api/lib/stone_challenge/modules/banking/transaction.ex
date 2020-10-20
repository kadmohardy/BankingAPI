defmodule StoneChallenge.Banking.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "transactions" do
    field :account_from, :string
    field :account_to, :string
    field :amount, :decimal
    field :type, :string
    field :date, :date

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:account_from, :account_to, :amount, :type, :date])
    |> validate_required([:account_from, :account_to, :amount, :type])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, ["bank_draft", "transfer"], message: "Invalid transaction type")
  end
end
