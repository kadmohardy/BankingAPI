defmodule StoneChallenge.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:account_number, :string, size: 6)
      add(:balance, :integer, default: 1000, null: false)
      add :user_id, references(:users)

      timestamps()
    end

    create(unique_index(:accounts, [:account_number]))
  end
end
