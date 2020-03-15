defmodule MonitorOtter.App do
  @moduledoc "The application module"

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      MonitorOtter.Repo,
      # Start the endpoint when the application starts
      MonitorOtterWeb.Endpoint,
      # Job check scheduler
      MonitorOtter.Job.Scheduler
    ]

    opts = [strategy: :one_for_one, name: MonitorOtter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MonitorOtterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
