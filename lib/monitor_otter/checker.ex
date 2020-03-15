defmodule MonitorOtter.Checker do
  @moduledoc """
  Checker behaviour.

  Defines a behaviour for a checker module. A checker is a component that verifies whether a page
  content has changed or not. Each checker might use different methods and user configuration to
  check page for changes. E.g. `MonitorOtter.Checker.Regex` uses regex with capture groups to
  capture particular information from the page and compare that against runs. Using that you can
  ignore changes you are not interested in and only monitor important information.
  """
  @typep state :: any()
  @typep config :: map()

  @doc """
  Checks for page changes.

  Given the page content, configuration and previous state it checks whether the page changed since
  last time. It returns new state that is to be passed as `prev_state` in the next run.

   - `{:no_change, state}` is returned if no change happened
   - `{:change_detected, state}` is returned if change occurred
   - `{:error, reason}` is returned if some error occurs
  """
  @callback check(content :: String.t(), config(), prev_state :: state()) ::
              {:no_change, state()} | {:change_detected, state()} | {:error, reason :: any()}

  # All implementations need to be registered here, the key is a type used in the Job model.
  @implementations %{
    "regex" => MonitorOtter.Checkers.Regex
  }

  @doc """
  Returns checker module for a given type.

  ## Examples
    iex> Checker.mod_for_type("regex")
    {:ok, MonitorOtter.Checkers.Regex}

    iex> Checker.mod_for_type("invalid")
    :error
  """
  def mod_for_type(type) do
    Map.fetch(@implementations, type)
  end

  @doc """
  Checks if given checker type is valid.

  ## Examples
    iex> Checker.type_valid?("regex")
    true

    iex> Checker.type_valid?("invalid")
    false
  """
  def type_valid?(type) do
    Map.has_key?(@implementations, type)
  end
end
