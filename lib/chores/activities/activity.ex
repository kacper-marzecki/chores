defmodule Chores.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :name, :string
    has_many :activity_tags, Chores.Activities.ActivityTag
    has_many :tags, through: [:activity_tags, :tag]
    timestamps()
  end

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: integer() | nil,
          name: String.t(),
          activity_tags: [Chores.Activities.ActivityTag.t()] | Ecto.Association.NotLoaded.t(),
          tags: [Chores.Activities.Tag.t()] | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @doc false
  def changeset(%__MODULE__{} = activity, attrs) do
    activity
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
