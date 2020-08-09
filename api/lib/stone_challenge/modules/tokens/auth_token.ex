defmodule StoneChallenge.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    field :user_id, :id

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
