defmodule ChoresWeb.TagControllerTest do
  use ChoresWeb.ConnCase

  alias Chores.Activities
  alias Chores.Activities.Tag
  alias Chores.Accounts

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}
  @existing_user %Chores.RegisterIn{
    login: "some login",
    password: "somepassword",
    secret: "registration_secret"
  }

  def fixture(:tag) do
    {:ok, tag} = Activities.create_tag(@create_attrs)
    tag
  end

  def fixture(:login) do
    {:ok, user} = Accounts.register(@existing_user)
    token = Accounts.generate_user_session_token(user)
    token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:login]

    test "lists all tags", %{conn: conn, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> get(Routes.tag_path(conn, :index))

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tag" do
    setup [:login]

    test "renders tag when data is valid", %{conn: conn, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> post(Routes.tag_path(conn, :create), tag: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> post(Routes.tag_path(conn, :create), tag: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tag" do
    setup [:login, :create_tag]

    test "renders tag when data is valid", %{
      conn: conn,
      tag: %Tag{id: id} = tag,
      user_token: token
    } do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> put(Routes.tag_path(conn, :update, tag), tag: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> put(Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tag" do
    setup [:login, :create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> delete(Routes.tag_path(conn, :delete, tag))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_path(conn, :show, tag))
      end
    end
  end

  defp create_tag(_) do
    tag = fixture(:tag)
    %{tag: tag}
  end

  defp login(_) do
    user_token = fixture(:login)
    %{user_token: user_token}
  end
end
