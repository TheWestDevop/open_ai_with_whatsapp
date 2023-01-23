defmodule WhatsAppClient do
  defdelegate verify_token(command),
    to: WhatsAppClient.VerifyToken,
    as: :call

  defdelegate message_checker(command),
    to: WhatsAppClient.MessageChecker,
    as: :call
end
