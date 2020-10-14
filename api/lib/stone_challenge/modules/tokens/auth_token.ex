defmodule StoneChallenge.AuthToken do
  @moduledoc """
  This module handle token creation and validation
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    belongs_to :user, StoneChallenge.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :revoked, :revoked_at])
    |> validate_required([:token, :revoked, :revoked_at])
    |> unique_constraint(:token)
  end
end
