defmodule Chores.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Chores.Repo

  alias Chores.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  alias Chores.Activities.ActivityTag

  @doc """
  Returns the list of activity_tags.

  ## Examples

      iex> list_activity_tags()
      [%ActivityTag{}, ...]

  """
  def list_activity_tags do
    Repo.all(ActivityTag)
  end

  @doc """
  Gets a single activity_tag.

  Raises `Ecto.NoResultsError` if the Activity tag does not exist.

  ## Examples

      iex> get_activity_tag!(123)
      %ActivityTag{}

      iex> get_activity_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_tag!(id), do: Repo.get!(ActivityTag, id)

  @doc """
  Creates a activity_tag.

  ## Examples

      iex> create_activity_tag(%{field: value})
      {:ok, %ActivityTag{}}

      iex> create_activity_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_tag(attrs \\ %{}) do
    %ActivityTag{}
    |> ActivityTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_tag.

  ## Examples

      iex> update_activity_tag(activity_tag, %{field: new_value})
      {:ok, %ActivityTag{}}

      iex> update_activity_tag(activity_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_tag(%ActivityTag{} = activity_tag, attrs) do
    activity_tag
    |> ActivityTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_tag.

  ## Examples

      iex> delete_activity_tag(activity_tag)
      {:ok, %ActivityTag{}}

      iex> delete_activity_tag(activity_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_tag(%ActivityTag{} = activity_tag) do
    Repo.delete(activity_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_tag changes.

  ## Examples

      iex> change_activity_tag(activity_tag)
      %Ecto.Changeset{data: %ActivityTag{}}

  """
  def change_activity_tag(%ActivityTag{} = activity_tag, attrs \\ %{}) do
    ActivityTag.changeset(activity_tag, attrs)
  end

  alias Chores.Activities.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
