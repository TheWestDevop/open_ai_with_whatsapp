defmodule AiWithWhatsapp.Admin.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :phone_number, :string
    field :message, :string
    field :ai_response, :string
    field :message_counter, :integer
    field :status, :string, default: "pending"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone_number, :message, :ai_response, :message_counter])
    |> validate_required([:phone_number, :message, :ai_response, :message_counter])
    |> unique_constraint(:phone_number)
  end
end
