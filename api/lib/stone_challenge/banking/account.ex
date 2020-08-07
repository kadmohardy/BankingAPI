defmodule StoneChallenge.Banking.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :code, :string
    field :balance, :integer
    field :user_id, :integer

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:code, :user_id])
    |> validate_required([:code, :user_id])
    |> unique_constraint([:code, :user_id])
  end
end
