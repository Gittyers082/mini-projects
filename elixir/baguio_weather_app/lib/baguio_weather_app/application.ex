defmodule BaguioWeatherApp.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BaguioWeatherAppWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:baguio_weather_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BaguioWeatherApp.PubSub},
      # Start a worker by calling: BaguioWeatherApp.Worker.start_link(arg)
      # {BaguioWeatherApp.Worker, arg},
      # Start to serve requests, typically the last entry
      BaguioWeatherAppWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BaguioWeatherApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BaguioWeatherAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
