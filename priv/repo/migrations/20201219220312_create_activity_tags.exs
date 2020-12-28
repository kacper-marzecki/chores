defmodule Chores.Repo.Migrations.CreateActivityTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add :name, :string,  primary_key: true

      timestamps()
    end

    create table(:activity_tags, primary_key: false) do
      add :activity_id, references(:activities)
      add :tag_id, references(:tags, column: :name, type: :string)

      timestamps()
    end



    create unique_index(:tags, [:name])
  end
end
