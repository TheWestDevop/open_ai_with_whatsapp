defmodule OpenAIClient.Client.ParseError do
  require Logger

  @provider_name "OpenAI"

  def call({:error, :timeout} = _result) do
    log_message = "OpenAI Timeout"

    Logger.error(log_message, type: :event)

    {:error, log_message}
  end

  def call(
        {:ok,
         %Tesla.Env{
           body: body
         }} = result
      ) do
    log_message = "OpenAI Error"
    Logger.error("#{log_message} ==> #{body}", type: :event)
    {:error, body}
  end

  def call(result) do
    log_message = "Undefined error"

    Logger.error("#{log_message} ==> #{result}", type: :event)

    {:error, "An error occurred. Try again later."}
  end
end
