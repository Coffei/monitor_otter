defmodule MonitorOtter.DAO.Jobs do
  @moduledoc """
  DAO for Job entity

  Defines common CRUD functions for `MonitorOtter.Models.Job`.
  """
  alias MonitorOtter.Models.Job
  alias MonitorOtter.Repo

  @doc """
  Returns all jobs.
  """
  def get_all do
    Repo.all(Job)
  end

  @doc """
  Create new job.
  """
  def create(job) do
    now = DateTime.utc_now()

    params =
      job
      |> Map.put(:created_at, now)
      |> Map.put(:changed_at, now)

    %Job{}
    |> Job.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update existing job.
  """
  def update(id, update) do
    case Repo.get(Job, id) do
      %Job{} = job ->
        params = Map.put(update, :changed_at, DateTime.utc_now())

        job
        |> Job.changeset(params)
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Mark a job as checked.

  `changed` says if the check detected a change. This updates various fields, like timestamps.
  """
  def mark_checked(id, changed) do
    now = DateTime.utc_now()

    params =
      if changed do
        %{last_check_at: now, last_check_change_at: now}
      else
        %{last_check_at: now}
      end

    case Repo.get(Job, id) do
      %Job{} = job ->
        job
        |> Job.changeset(params)
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Delete a job.
  """
  def delete(id) do
    case Repo.get(Job, id) do
      %Job{} = job -> Repo.delete(job)
      _ -> {:error, :not_found}
    end
  end
end
