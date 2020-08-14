defmodule StoneChallenge.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :password_hash, :string
      add :customer, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
