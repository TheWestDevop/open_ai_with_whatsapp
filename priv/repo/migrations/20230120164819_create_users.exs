defmodule AiWithWhatsapp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :phone_number, :string, null: false
      add :message, :text, null: false
      add :message_counter, :integer, null: false
      add :ai_response, :text, null: false
      add :status, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:phone_number])
  end
end
