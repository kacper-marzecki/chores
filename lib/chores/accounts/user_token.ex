defmodule Chores.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @rand_size 32

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @session_validity_in_days 60

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    belongs_to :user, Chores.Accounts.User

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %Chores.Accounts.UserToken{token: token, context: "session", user_id: user.id}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the user found by the token.
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  def token_and_context_query(token, context) do
    from Chores.Accounts.UserToken, where: [token: ^token, context: ^context]
  end

  def user_and_context_query(user_id, context) do
    from Chores.Accounts.UserToken, where: [user_id: ^user_id, context: ^context]
  end
end
