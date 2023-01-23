defmodule WhatsAppClient.MessageChecker do
  require Logger

  alias AiWithWhatsapp.Admin
  alias OpenAIClient.Client, as: OpenAI
  alias WhatsAppClient.MessageSender

  @type t :: %__MODULE__{
          message: list(map())
        }

  defstruct [:message]

  @spec call(%__MODULE__{}) :: :ok
  def call(%__MODULE__{} = command) do
    Enum.each(command.message, fn msg ->
      %{
        "from" => phone_number,
        "text" => %{
          "body" => user_message
        },
        "type" => "text"
      } = msg

      log_message = "WhatsApp Channel Received Message From #{phone_number}"
      Logger.info(log_message, type: :event)
      result = process_text(user_message)
      db_record = Admin.create_or_update(phone_number, user_message, result)

      case MessageSender.call(%MessageSender{
             message_component: %{
               "text" => result
             },
             phone_number: String.replace(phone_number, "+", ""),
             type: "text"
           }) do
        :ok ->
          :ok

        {:error, _res} ->
          Admin.update_user(db_record, %{status: "failed"})
      end
    end)
  end

  def call(_), do: {:error, "wrong command"}

  defp process_text(text) do
    case OpenAI.search_text(text) do
      {:ok,
       %Tesla.Env{
         status: 200,
         body: %{"choices" => results}
       }} ->
        [h | _] = results
        h["text"]

      error ->
        Logger.info(Kernel.inspect(error), type: :event)
        "Nothing found"
    end
  end
end
