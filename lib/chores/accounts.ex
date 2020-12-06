defmodule Chores.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Chores.Repo
  alias Chores.Accounts.User
  alias Chores.Accounts.UserToken

  @doc """
  Creates a user.

  ## Examples

      iex> register(%{field: value})
      {:ok, %User{}}

      iex> register(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register(%{"password" => _password, "login"=> _login} = params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end



 @spec get_user_by_login(binary) :: any
 @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_login(login) when is_binary(login) do
    Repo.get_by(User, login: login)
  end

 @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_login_and_password(login, password)
      when is_binary(login) and is_binary(password) do
    user = Repo.get_by(User, login: login)
    if User.valid_password?(user, password), do: user
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end


  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the session token 
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

end