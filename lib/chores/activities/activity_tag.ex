defmodule Chores.Activities.ActivityTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema("activity_tags") do
    belongs_to :activity, Chores.Activities.Activity
    belongs_to :tag, Chores.Activities.Tag, references: :name
    timestamps()
  end

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          activity: [Chores.Activities.Activity.t()] | Ecto.Association.NotLoaded.t(),
          tag: [Chores.Activities.Tag.t()] | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @doc false
  def changeset(activity_tag, attrs) do
    activity_tag
    |> cast(attrs, [:tag_id, :activity_id])
    |> validate_required([:tag_id, :activity_id])
  end
end
