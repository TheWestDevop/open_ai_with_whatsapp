defmodule AiWithWhatsapp.Repo do
  use Ecto.Repo,
    otp_app: :ai_with_whatsapp,
    adapter: Ecto.Adapters.Postgres
end
