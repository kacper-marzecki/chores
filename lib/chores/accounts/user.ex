defmodule Chores.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :login, :string
    field :password, :string
    field :role, :string

    timestamps()
  end

  @type t() :: %__MODULE__{
    __meta__: Ecto.Schema.Metadata.t(),
    id: integer() | nil,
    login: String.t(),
    password: String.t(),
    role: String.t(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:login, :password, :role])
    |> validate_required([:login, :password, :role])
    |> unique_constraint(:login)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(%Chores.LoginIn{} = attrs) do
    IO.puts(inspect(attrs))
    %Chores.Accounts.User{}
    |> cast(Map.from_struct(attrs), [:login, :password])
    |> validate_login()
    |> validate_password()
    |> validate_required([:login, :password])
    |> hash_password()
  end

  defp validate_login(changeset) do
    changeset
    |> validate_required([:login])
    # |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:login, max: 160)
    |> unsafe_validate_unique(:login, Chores.Repo)
    |> unique_constraint(:login)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)

    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      |> put_change(:password, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Chores.Accounts.User{password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  #  @doc """
  # Validates the current password otherwise adds an error to the changeset.
  # """
  # def validate_current_password(changeset, password) do
  #   if valid_password?(changeset.data, password) do
  #     changeset
  #   else
  #     add_error(changeset, :current_password, "is not valid")
  #   end
  # end
end
