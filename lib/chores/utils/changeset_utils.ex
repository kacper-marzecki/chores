defmodule Chores.ChangesetUtils do
  import Ecto.Changeset

  @spec validate(Ecto.Changeset.t()) :: {:error, Ecto.Changeset.t()} | {:ok, any()}
  def validate(changeset) do
    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
