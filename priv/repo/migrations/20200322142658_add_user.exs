defmodule MonitorOtter.Repo.Migrations.AddUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :created_at, :utc_datetime
      add :changed_at, :utc_datetime
    end

    create unique_index(:user, [:email])
  end
end
