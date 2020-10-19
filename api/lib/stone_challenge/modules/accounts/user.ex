defmodule StoneChallenge.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "customer"

    has_one :accounts, StoneChallenge.Accounts.Account
    has_many :auth_tokens, StoneChallenge.AuthToken
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(
      params,
      [:email, :first_name, :last_name, :password, :password_confirmation, :role]
    )
    |> validate_required([
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_format(:email, ~r/@/, message: "Invalid mail format")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password,
      min: 6,
      message: "Password should be at least 6 character(s)"
    )
    |> validate_confirmation(:password, message: "Passwords are different")
    |> unique_constraint(:email, message: "This mail address already used by an user")
    |> put_pass_hash()
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
