use Mix.Config

# Configure your database
config :monitor_otter, MonitorOtter.Repo,
  username: "postgres",
  password: "postgres",
  database: "monitor_otter_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Mocks
config :monitor_otter,
  http_impl: MonitorOtter.Mocks.Http

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :monitor_otter, MonitorOtterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Swoosh configuration
config :monitor_otter, MonitorOtterWeb.Mailer,
  adapter: Swoosh.Adapters.Test,
  from: "test@test.com"

# Lower Bcrypt rounds in tests
config :bcrypt_elixir, log_rounds: 4
