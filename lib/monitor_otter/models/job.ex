defmodule MonitorOtter.Models.Job do
  @moduledoc """
  Job model.
  """
  use Ecto.Schema
  alias MonitorOtter.Models.User

  import Ecto.Changeset,
    only: [
      cast: 3,
      validate_required: 2,
      validate_length: 3,
      validate_change: 3,
      validate_format: 3,
      put_assoc: 3
    ]

  alias MonitorOtter.Models.Types.JobState
  alias MonitorOtter.Checker

  schema "job" do
    field :name, :string
    field :enabled, :boolean
    field :url, :string
    field :checker_type, :string
    field :checker_config, :map
    field :notification_email, :string
    field :last_state, JobState
    field :last_check_at, :utc_datetime
    field :last_check_change_at, :utc_datetime
    field :created_at, :utc_datetime
    field :changed_at, :utc_datetime
    belongs_to :user, User
  end

  @doc "Create a job changeset."
  def changeset(job, params) do
    job
    |> cast(params, [
      :name,
      :enabled,
      :url,
      :checker_type,
      :checker_config,
      :notification_email,
      :last_state,
      :last_check_at,
      :last_check_change_at,
      :created_at,
      :changed_at
    ])
    |> conditionally_put_assoc(:user, params[:user])
    |> validate_required([
      :name,
      :enabled,
      :url,
      :checker_type,
      :checker_config,
      :notification_email,
      :created_at,
      :changed_at,
      :user
    ])
    |> validate_length(:name, min: 3, max: 256)
    |> validate_checker_type(:checker_type)
    |> validate_length(:url, min: 3)
    |> validate_format(:notification_email, ~r/.+@.+/)
  end

  defp conditionally_put_assoc(changeset, _, nil) do
    changeset
  end

  defp conditionally_put_assoc(changeset, field, value) do
    put_assoc(changeset, field, value)
  end

  defp validate_checker_type(changeset, field) do
    validate_change(changeset, field, fn _, checker_type ->
      if Checker.type_valid?(checker_type) do
        []
      else
        [{field, "checker type is invalid"}]
      end
    end)
  end
end
