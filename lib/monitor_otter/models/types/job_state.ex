defmodule MonitorOtter.Models.Types.JobState do
  @moduledoc """
  Custom Ecto type for Job state.

  Job state is basically any Elixir term, so this type encodes to binary with
  `:erlang.term_to_binary/1`.
  """
  use Ecto.Type

  @impl true
  def type, do: :bytea

  @impl true
  def cast(thing), do: {:ok, thing}

  @impl true
  def load(encoded) when is_binary(encoded) do
    {:ok, :erlang.binary_to_term(encoded)}
  end

  @impl true
  def dump(term) do
    {:ok, :erlang.term_to_binary(term)}
  end
end
