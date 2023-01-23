defmodule AiWithWhatsappWeb.UserView do
  use AiWithWhatsappWeb, :view
  alias AiWithWhatsappWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      phone_number: user.phone_number,
      message: user.message,
      ai_response: user.ai_response,
      message_counter: user.message_counter,
      status: user.status
    }
  end
end
