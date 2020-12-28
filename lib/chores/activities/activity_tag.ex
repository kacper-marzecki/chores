defmodule Chores.Activities.ActivityTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_tags" do
    belongs_to :activity, Chores.Activities.Activity
    belongs_to :tag, Chores.Activities.Tag
    timestamps()
  end

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: integer() | nil,
          activity: [Chores.Activities.Activity.t()] | Ecto.Association.NotLoaded.t(),
          tag: [Chores.Activities.Tag.t()] | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @doc false
  def changeset(activity_tag, attrs) do

    activity_tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
