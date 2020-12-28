defmodule Chores.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string

      timestamps()
    end
    create unique_index(:activities, [:name])

  end
end
