defmodule MonitorOtter.Checkers.Regex do
  @moduledoc """
  Regex checker.

  Uses regex to check if page changed or not. It executes the configured regex and compares all but
  first capture groups with the last run. Therefore, the regex should specify at least one capture
  group, otherwise the checker will not do anything. Note the first capture group (the whole matched
  string) is ignored.
  """
  @behaviour MonitorOtter.Checker

  @impl true
  def check(content, %{"regex" => regex}, prev_state) do
    with {:ok, regex} <- Regex.compile(regex) do
      current_matches = Regex.run(regex, content, capture: :all_but_first)

      if current_matches == prev_state do
        {:no_change, current_matches}
      else
        {:change_detected, current_matches}
      end
    else
      {:error, reason} -> {:error, {:invalid_regex, reason}}
    end
  end
end
