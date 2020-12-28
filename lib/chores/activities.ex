defmodule Chores.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Chores.Repo

  alias Chores.Activities.Activity

  @spec list_activities :: [Activity.t()]
  def list_activities do
    Repo.all(Activity)
  end

  def get_activity!(id), do: Repo.get!(Activity, id)

  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end


  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end


  alias Chores.Activities.ActivityTag

  @spec list_activity_tags :: [ActivityTag.t()]
  def list_activity_tags do
    Repo.all(ActivityTag)
  end

  @spec get_activity_tag!(integer()) :: ActivityTag.t()
  def get_activity_tag!(id), do: Repo.get!(ActivityTag, id)

  def create_activity_tag(attrs \\ %{}) do
    %ActivityTag{}
    |> ActivityTag.changeset(attrs)
    |> Repo.insert()
  end

  def update_activity_tag(%ActivityTag{} = activity_tag, attrs) do
    activity_tag
    |> ActivityTag.changeset(attrs)
    |> Repo.update()
  end

  def delete_activity_tag(%ActivityTag{} = activity_tag) do
    Repo.delete(activity_tag)
  end

  alias Chores.Activities.Tag

  def list_tags do
    Repo.all(Tag)
  end

  @spec get_tag!(integer()) :: Tag.t()
  def get_tag!(id), do: Repo.get!(Tag, id)

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_tag(
          Chores.Activities.Tag.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end


  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end


  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
