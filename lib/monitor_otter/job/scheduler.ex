defmodule MonitorOtter.Job.Scheduler do
  @moduledoc """
  Takes care of job scheduling.

  Currently jobs have no custom scheduling, all jobs are checked every hour. It's a GenServer, so
  just start it and let it do its thing.
  """
  use GenServer
  require Logger
  alias MonitorOtter.DAO.Jobs
  alias MonitorOtter.Job.Processor

  @schedule %Crontab.CronExpression{
    extended: false,
    second: [0],
    minute: [0],
    hour: [:*],
    day: [:*],
    month: [:*],
    weekday: [:*],
    year: [:*]
  }

  @doc "Start the server"
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    setup_timeout()
    {:ok, nil}
  end

  @impl true
  def handle_info(:check_jobs, state) do
    Logger.info("Checking all jobs")

    Jobs.get_all()
    |> Enum.filter(& &1.enabled)
    |> Enum.each(&Processor.process/1)

    setup_timeout()
    {:noreply, state}
  end

  defp setup_timeout() do
    now = NaiveDateTime.utc_now()

    case Crontab.Scheduler.get_next_run_date(@schedule, now) do
      {:ok, next_target_naive} ->
        next_target_ts =
          next_target_naive
          |> DateTime.from_naive!("Etc/UTC")
          |> DateTime.to_unix(:millisecond)

        timeout_ts = next_target_ts - System.os_time(:millisecond)
        Process.send_after(__MODULE__, :check_jobs, timeout_ts)

      _ ->
        :error
    end
  end
end
