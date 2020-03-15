defmodule MonitorOtter.Job.Processor do
  @moduledoc """
  Processes a job.

  Based on the job configuration, it fetches the page and uses appropriate checker module to see if
  a change occurred on the page. If it did, user is notified of that change with an email. Finally,
  all the information is stored back in storage.
  """
  require Logger
  alias MonitorOtter.Checker
  alias MonitorOtter.DAO.Jobs
  alias MonitorOtter.Models.Job
  alias MonitorOtterWeb.Mailer
  alias MonitorOtterWeb.UserEmail

  @http_mod Application.get_env(:monitor_otter, :http_impl)

  @doc """
  Process a job.
  """
  def process(%Job{
        id: id,
        name: name,
        url: url,
        checker_type: checker_type,
        checker_config: checker_config,
        last_state: last_state
      }) do
    Logger.info("Checking job #{name}")

    with {:ok, content} <- @http_mod.fetch(url),
         {:ok, checker_mod} <- Checker.mod_for_type(checker_type),
         {:change_detected, new_state} <- checker_mod.check(content, checker_config, last_state),
         {:ok, _} <- Jobs.update(id, %{last_state: new_state}),
         {:ok, job} <- Jobs.mark_checked(id, true) do
      Logger.info("Change found for job #{name}")
      notify_user(job, last_state)
      :ok
    else
      {:no_change, _state} ->
        Logger.info("No change for job #{name}")
        Jobs.mark_checked(id, false)
        :ok

      error ->
        Logger.warn("Error in job #{name}: #{inspect(error)}")
        :error
    end
  end

  defp notify_user(job, previous_state) do
    res =
      job
      |> UserEmail.change_detected(previous_state)
      |> Mailer.deliver()

    case res do
      {:error, reason} ->
        Logger.warn("Could not send email for job #{job.name}, reason: #{inspect(reason)}")

      _ ->
        :ok
    end
  end
end
