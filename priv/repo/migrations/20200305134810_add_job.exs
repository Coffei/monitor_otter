defmodule MonitorOtter.Repo.Migrations.AddJob do
  use Ecto.Migration

  def change do
    create table(:job) do
      add :name, :string
      add :enabled, :boolean
      add :url, :string
      add :checker_type, :string
      add :checker_config, :map
      add :notification_email, :string
      add :last_state, :bytea
      add :last_check_at, :utc_datetime
      add :last_check_change_at, :utc_datetime
      add :created_at, :utc_datetime
      add :changed_at, :utc_datetime
    end
  end
end
