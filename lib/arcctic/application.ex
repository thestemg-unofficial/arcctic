defmodule Arcctic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ArccticWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:arcctic, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Arcctic.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Arcctic.Finch},
      # Start a worker by calling: Arcctic.Worker.start_link(arg)
      # {Arcctic.Worker, arg},
      # Start to serve requests, typically the last entry
      ArccticWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arcctic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArccticWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
