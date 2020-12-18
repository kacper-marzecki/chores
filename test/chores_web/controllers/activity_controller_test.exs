defmodule ChoresWeb.ActivityControllerTest do
  use ChoresWeb.ConnCase

  alias Chores.Activities
  alias Chores.Activities.Activity
  alias Chores.Accounts
  require IEx

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

  def fixture(:user) do
    {:ok, user} = Accounts.register(@existing_user)
    token = Accounts.generate_user_session_token(user)
    token
  end

  def fixture(:activity) do
    {:ok, activity} = Activities.create_activity(@create_attrs)
    activity
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all activities", %{conn: conn, user_token: token} do
      conn = Plug.Test.init_test_session(conn, user_token: token)
      conn = get(conn, Routes.activity_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create activity" do
    setup [:create_user]

    test "renders activity when data is valid", %{conn: conn, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> post(Routes.activity_path(conn, :create), activity: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.activity_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> post(Routes.activity_path(conn, :create), activity: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update activity" do
    setup [:create_user, :create_activity]

    test "renders activity when data is valid", %{
      conn: conn,
      activity: %Activity{id: id} = activity,
      user_token: token
    } do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> put(Routes.activity_path(conn, :update, activity), activity: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.activity_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      activity: activity,
      user_token: token
    } do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> put(Routes.activity_path(conn, :update, activity), activity: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete activity" do
    setup [:create_user, :create_activity]

    test "deletes chosen activity", %{conn: conn, activity: activity, user_token: token} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> delete(Routes.activity_path(conn, :delete, activity))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.activity_path(conn, :show, activity))
      end
    end
  end

  defp create_activity(_) do
    activity = fixture(:activity)
    %{activity: activity}
  end

  defp create_user(_) do
    user_token = fixture(:user)
    %{user_token: user_token}
  end
end
