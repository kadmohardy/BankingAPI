defmodule StoneChallenge.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :text
      add :revoked, :boolean, default: false, null: false
      add :revoked_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create unique_index(:auth_tokens, [:token])
    create index(:auth_tokens, [:user_id])
  end
end
