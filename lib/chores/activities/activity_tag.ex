defmodule Chores.Activities.ActivityTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_tags" do
    belongs_to :activity, Chores.Activities.Activity
    belongs_to :tag, Chores.Activities.Tag
    timestamps()
  end

  @doc false
  def changeset(activity_tag, attrs) do
    activity_tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
