use Mix.Config

config :monitor_otter, MonitorOtter.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
  raise """
  environment variable SECRET_KEY_BASE is missing.
  You can generate one by calling: mix phx.gen.secret
  """

config :monitor_otter, MonitorOtterWeb.Endpoint,
  server: true,
  url: [host: System.get_env("HOSTNAME"), port: 80],
  http: [
    port: String.to_integer(System.get_env("PORT") || "80"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :monitor_otter, MonitorOtterWeb.Mailer,
  relay: System.get_env("SMTP_RELAY"),
  username: System.get_env("SMTP_USER"),
  password: System.get_env("SMTP_PASSWORD"),
  ssl: System.get_env("SMTP_USE_SSL") == "true",
  tls: String.to_atom(System.get_env("SMTP_USE_TLS", "always")),
  auth: String.to_atom(System.get_env("SMTP_AUTH", "always")),
  port: String.to_integer(System.get_env("SMTP_PORT", "587")),
  from: System.get_env("SMTP_FROM")
