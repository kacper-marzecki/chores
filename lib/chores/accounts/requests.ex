defmodule Chores.RegisterIn do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:password, :login, :secret]
  schema "RegisterIn" do
    field :password, :string
    field :login, :string
    field :secret, :string
  end

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          login: String.t(),
          password: String.t(),
          secret: String.t()
        }
  @spec create(map()) :: {:error, Ecto.Changeset.t()} | {:ok, Chores.RegisterIn.t()}
  def create(params) do
    res =
      %Chores.RegisterIn{}
      |> cast(params, [:password, :login, :secret], required: true)
      |> validate_required(@fields)

    inspect(res)

    if res.valid? do
      {:ok, apply_changes(res)}
    else
      {:error, res}
    end
  end
end
