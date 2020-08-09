defmodule StoneChallenge.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :integer
      add :type, :integer
      add :user_id, references(:users)
      add :target_account_number, :string

      timestamps()
    end
  end
end
