defmodule ChoresWeb.UserControllerTest do
  use ChoresWeb.ConnCase

  alias Chores.Accounts
  alias Chores.Accounts.User

  @existing_user %{
    "login" => "some login",
    "password" => "somepassword",
    "role" => "some role"
  }

  @register_in %Chores.RegisterIn{
    login: "some login",
    password: "somepassword",
    secret: "registration_secret"
  }

  @invalid_attrs %{login: nil, password: nil, role: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.register(@register_in)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    test "registers user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :register), Map.from_struct(@register_in))
      assert response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :register), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test " when data is invalid", %{conn: conn} do
      fixture(:user)
      conn = post(conn, Routes.user_path(conn, :register), Map.from_struct(@register_in))
      assert json_response(conn, 422)["errors"]["login"] == ["has already been taken"]
    end
  end

  describe "login user" do
    setup [:create_user]

    test "logins user if the credentials are ok", %{conn: conn, user: %User{} = _user} do
      conn = post(conn, Routes.user_path(conn, :login, @existing_user))
      assert response(conn, 201)
      assert conn.resp_cookies != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, user: _user} do
      conn = post(conn, Routes.user_path(conn, :login, @invalid_attrs))
      assert response(conn, 403)
    end
  end

  # describe "delete user" do
  #   setup [:create_user]

  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete(conn, Routes.user_path(conn, :delete, user))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.user_path(conn, :show, user))
  #     end
  #   end
  # end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
