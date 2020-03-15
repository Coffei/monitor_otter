defmodule MonitorOtter.Repo do
  @moduledoc "Ecto repository"
  use Ecto.Repo,
    otp_app: :monitor_otter,
    adapter: Ecto.Adapters.Postgres
end
