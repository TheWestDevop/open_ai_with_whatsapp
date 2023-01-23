defmodule AiWithWhatsappWeb.WhatsAppController do
  use AiWithWhatsappWeb, :controller

  def verify(conn, params) do
    with :ok <-
           WhatsAppClient.verify_token(%VerifyCommand{
             token: params["hub.verify_token"],
             mode: params["hub.mode"]
           }) do
      conn |> send_resp(200, params["hub.challenge"])
    else
      _any_error -> conn |> send_resp(403, "")
    end
  end

  def receive_message(
        conn,
        %{
          "entry" => [
            %{
              "changes" => [
                %{
                  "value" => %{
                    "messages" => message
                  }
                }
              ]
            }
          ]
        }
      ) do
    _ =
      WhatsAppClient.message_checker(%MessageCheckerCommand{
        message: message
      })

    conn |> send_resp(200, "")
  end

  def receive_message(
        conn,
        _params
      ) do
    conn |> send_resp(200, "unhandle message from whatsapp webhook")
  end
end
