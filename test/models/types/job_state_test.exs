defmodule MonitorOtter.Models.Types.JobStateTest do
  use ExUnit.Case
  alias MonitorOtter.Models.Types.JobState

  test "any term is encoded and decoded correctly" do
    for thing <- [
          :atom,
          1,
          'thing',
          "thing",
          %{atom: :map},
          %{"string" => "map"},
          %{deep: %{map: %{also: %{ok: true}}}}
        ] do
      {:ok, encoded} = JobState.dump(thing)
      {:ok, decoded} = JobState.load(encoded)

      assert thing === decoded
    end
  end
end
