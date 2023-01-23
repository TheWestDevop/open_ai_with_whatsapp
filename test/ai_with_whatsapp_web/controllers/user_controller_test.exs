defmodule AiWithWhatsappWeb.UserControllerTest do
  use AiWithWhatsappWeb.ConnCase

  import AiWithWhatsapp.AdminFixtures

  alias AiWithWhatsapp.Admin.User

  @create_attrs %{
    ai_response: "some ai_response",
    message: "some message",
    message_counter: 42,
    phone_number: "some phone_number",
    status: "some status"
  }
  @update_attrs %{
    ai_response: "some updated ai_response",
    message: "some updated message",
    message_counter: 43,
    phone_number: "some updated phone_number",
    status: "some updated status"
  }
  @invalid_attrs %{ai_response: nil, message: nil, message_counter: nil, phone_number: nil, status: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "ai_response" => "some ai_response",
               "message" => "some message",
               "message_counter" => 42,
               "phone_number" => "some phone_number",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "ai_response" => "some updated ai_response",
               "message" => "some updated message",
               "message_counter" => 43,
               "phone_number" => "some updated phone_number",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
