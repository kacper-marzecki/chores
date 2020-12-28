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

  def fixture(:login) do
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
    setup [:login]

    test "lists all activities", %{conn: conn, user_token: token} do
      conn = Plug.Test.init_test_session(conn, user_token: token)
      conn = get(conn, Routes.activity_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create activity" do
    setup [:login]

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
    setup [:login, :create_activity]

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

  describe "create an duplicate activity" do
    setup [:login, :create_activity]

    test "cannot create an activity with a duplicated name ", %{
      conn: conn,
      activity: %Activity{id: id} = activity,
      user_token: token
    } do
      conn =
        conn
        |> Plug.Test.init_test_session(user_token: token)
        |> post("api/activities/", activity: @create_attrs)

      assert %{"name" => ["has already been taken"]} = json_response(conn, 422)["errors"]
    end
  end

  describe "delete activity" do
    setup [:login, :create_activity]

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

  defp login(_) do
    user_token = fixture(:login)
    %{user_token: user_token}
  end
end
