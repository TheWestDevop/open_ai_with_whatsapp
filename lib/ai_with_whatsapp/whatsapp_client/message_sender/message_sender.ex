defmodule WhatsAppClient.MessageSender do
  alias WhatsAppClient.Client
  alias WhatsAppClient.Client.ParseError
  require Logger

  @type t :: %__MODULE__{
          phone_number: String.t(),
          message_component: map(),
          type: String.t()
        }
  defstruct [:phone_number, :message_component, :type]

  @spec call(%__MODULE__{}) :: :ok | {:error, :forbidden}
  def call(%__MODULE__{} = command) do
    with false <- is_empty?(command.phone_number),
         false <- is_empty?(command.type),
         {:ok, _msg} <- send_message(command) do
      :ok
    end
  end

  def call(_), do: {:error, "wrong command"}

  defp send_message(%{type: "text"} = content) do
    body = build_text_message_body(content.message_component["text"], content.phone_number)

    case client().reply(body) do
      {:ok,
       %Tesla.Env{
         status: 200,
         body:
           %{"messaging_product" => "whatsapp", "messages" => _messages, "contacts" => _contact} =
               response_body
       }} ->
        log_message = "WhatsApp Send Message to #{content.phone_number} Successful"
        Logger.info(log_message, type: :event)
        {:ok, parse_response(response_body, body)}

      error ->
        log_message = "WhatsApp Send Message Error"
        Logger.info(log_message, type: :event)
        ParseError.call(error)
    end
  end

  defp client, do: Client

  @spec build_text_message_body(String.t(), String.t()) :: map
  defp build_text_message_body(response, owner) do
    %{
      "messaging_product" => "whatsapp",
      "to" => owner,
      text: %{body: response}
    }
  end

  defp parse_response(%{"messages" => [%{"id" => message_id}]} = _response_body, _body) do
    %{
      message_id: message_id
    }
  end

  defp is_empty?(nil), do: true
  defp is_empty?(val), do: val |> String.trim() |> String.length() === 0
end
