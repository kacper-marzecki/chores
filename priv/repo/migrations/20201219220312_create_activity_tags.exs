defmodule Chores.Repo.Migrations.CreateActivityTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps()
    end
    
    create table(:activity_tags, primary_key: false) do
      add :activity, references(:activities)
      add :tag, references(:tags)

      timestamps()
    end



    create unique_index(:tags, [:name])
  end
end
