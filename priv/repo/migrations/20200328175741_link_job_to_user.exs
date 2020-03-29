defmodule MonitorOtter.Repo.Migrations.LinkJobToUser do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :user_id, references(:user)
    end
  end
end
