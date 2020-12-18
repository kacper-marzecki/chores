defmodule Chores.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :name, :string

    timestamps()
  end
  
  @type t() :: %__MODULE__{
    __meta__: Ecto.Schema.Metadata.t(),
    id: integer() | nil,
    name: String.t(),
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
