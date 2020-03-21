defmodule MonitorOtter.ReleaseTasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql # If using Ecto 3.0 or higher
  ]

  @repo MonitorOtter.Repo

  def migrate(_argv) do
    {:ok, _} = Application.ensure_all_started(:monitor_otter)

    run_migrations()
  end

  def seed(_argv) do
    {:ok, _} = Application.ensure_all_started(:monitor_otter)

    run_migrations()

    run_seeds()
  end

  defp run_migrations do
    run_migrations_for(@repo)
  end

  defp run_migrations_for(repo) do
    IO.puts("Running migrations for #{repo}")
    migrations_path = priv_path_for(repo, "migrations")
    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp run_seeds do
    Enum.each(@repos, &run_seeds_for/1)
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = priv_path_for(repo, "seeds.exs")

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
