defmodule StoneChallenge.Repo.Migrations.CreateTransactionTypes do
  use Ecto.Migration

  def change do
    create table(:transaction_types) do
      add :description, :integer
    end
  end
end
