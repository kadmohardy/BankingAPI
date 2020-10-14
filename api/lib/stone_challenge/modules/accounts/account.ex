defmodule StoneChallenge.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    belongs_to :user, StoneChallenge.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:balance])
    |> validate_required([:balance])
  end

  def update_changeset(account, params \\ %{}) do
    account
    |> cast(params, [:balance])
  end
end
