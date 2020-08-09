defmodule StoneChallenge.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :account, StoneChallenge.Banking.Account
    has_many :auth_tokens, StoneChallenge.AuthToken
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
