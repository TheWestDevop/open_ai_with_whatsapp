defmodule AiWithWhatsapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AiWithWhatsapp.Repo,
      # Start the Telemetry supervisor
      AiWithWhatsappWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AiWithWhatsapp.PubSub},
      # Start the Endpoint (http/https)
      AiWithWhatsappWeb.Endpoint,



      # WhatsAppClient.Application,
      # OpenAIClientClient.Application

      # Start a worker by calling: AiWithWhatsapp.Worker.start_link(arg)
      # {AiWithWhatsapp.Worker, name: AiWithWhatsapp.Worker}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiWithWhatsapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiWithWhatsappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
