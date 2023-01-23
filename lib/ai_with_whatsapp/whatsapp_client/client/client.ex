defmodule WhatsAppClient.Client do
  alias WhatsAppClient.Client.AuthenticatedAPI, as: API

  def reply(body) do
    "whatsapp_send_message"
    |> API.client()
    |> Tesla.post("/#{phone_number()}/messages", body)
  end

  defp phone_number, do: Application.get_env(:whatsapp_client, :phone_number)
end
