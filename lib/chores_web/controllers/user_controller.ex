defmodule ChoresWeb.UserController do
  use ChoresWeb, :controller

  alias Chores.Accounts
  alias ChoresWeb.UserAuth
  # alias Chores.Accounts.User

  action_fallback ChoresWeb.FallbackController

  def register(
        conn,
        %{"password" => _password, "login" => _login, "secret" => _secret} = params
      ) do
    with {:ok, user} <- Accounts.register(params) do
      conn
      |> UserAuth.log_in_user(user)
    end
  end

  # TODO change input
  def login(conn, user_params) do
    %{"login" => login, "password" => password} = user_params

    with {:ok, user} <- Accounts.get_user_by_login_and_password(login, password) do
      UserAuth.log_in_user(conn, user)
    end
  end

  # def logout(conn, opts) do

  # end

  def test(conn, _opts) do
    login = UserAuth.extract_user(conn).login
    json(conn, %{"login" => login})
  end

  def logout(conn, _opts) do
    IO.puts(inspect(conn.assigns[:current_user], pretty: true))
    UserAuth.log_out_user(conn)
  end
end
