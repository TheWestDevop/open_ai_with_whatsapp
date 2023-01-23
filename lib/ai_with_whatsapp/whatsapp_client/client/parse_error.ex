defmodule WhatsAppClient.Client.ParseError do
  require Logger

  @provider_name "WhatsApp"

  def call({:error, :timeout} = _result) do
    log_message = "WhatsApp Timeout"

    Logger.error(log_message, type: :event)

    {:error, log_message}
  end

  def call(
        {:ok,
         %Tesla.Env{
           body:
             %{
               "error" => %{
                 "message" => message,
                 "fbtrace_id" => _fbtrace_id,
                 "code" => _code,
                 "type" => _type
               }
             } = body
         }} = result
      ) do
    log_message = "WhatsApp Error"
    Logger.error("#{log_message} ==> #{body}", type: :event)
    {:error, message}
  end

  def call(result) do
    log_message = "Undefined error"

    Logger.error("#{log_message} ==> #{result}", type: :event)

    {:error, "An error occurred. Try again later."}
  end
end
