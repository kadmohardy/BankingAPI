defmodule StoneChallenge.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :integer
      add :transaction_types_id, references(:transaction_types)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
