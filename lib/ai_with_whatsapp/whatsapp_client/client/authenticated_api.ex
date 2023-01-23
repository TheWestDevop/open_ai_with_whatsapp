defmodule WhatsAppClient.Client.AuthenticatedAPI do

  def client(endpoint) do
    [
      {Tesla.Middleware.BaseUrl, base_url()},
      {Tesla.Middleware.Opts, [provider: "WhatsApp", endpoint: endpoint]},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Telemetry,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "Bearer #{access_token()}"}
       ]}
    ]
    |> Tesla.client({Tesla.Adapter.Hackney, pool: "100"})
  end

  defp base_url, do: Application.get_env(:whatsapp_client, :base_url)
  defp access_token, do: Application.get_env(:whatsapp_client, :access_token)
end
