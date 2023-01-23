defmodule OpenAIClient.Client.AuthenticatedAPI do
  def client(endpoint) do
    [
      {Tesla.Middleware.BaseUrl, base_url()},
      {Tesla.Middleware.Opts, [provider: "OpenAI", endpoint: endpoint]},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Telemetry,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "Bearer #{access_token()}"},
         {"OpenAI-Organization", "#{identifier_token()}"}
       ]}
    ]
    |> Tesla.client({Tesla.Adapter.Hackney, pool: "100"})
  end

  defp base_url, do: Application.get_env(:open_ai, :base_url)
  defp access_token, do: Application.get_env(:open_ai, :access_key)
  defp identifier_token, do: Application.get_env(:open_ai, :identifier_org)
end
