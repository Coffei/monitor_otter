defmodule MonitorOtter.Checkers.RegexTest do
  use ExUnit.Case

  alias MonitorOtter.Checkers.Regex

  test "initial match" do
    content = "something 2 match"

    assert Regex.check(content, config("(som.+) (\\d) match"), :initial) ==
             {:change_detected, ["something", "2"]}
  end

  test "initial non-match" do
    content = "short"
    assert Regex.check(content, config("invalid match"), :initial) == {:change_detected, nil}
  end

  test "match without change" do
    content1 = "string 2 match"
    content2 = "stuff 2 do"
    config = config("(\\d)")
    {:change_detected, ["2"] = state} = Regex.check(content1, config, :initial)

    assert {:no_change, new_state} = Regex.check(content2, config, state)
    assert new_state == state
  end

  test "match with change" do
    content1 = "string 2 match"
    content2 = "stuff 4 me"
    config = config("(\\d)")
    {:change_detected, ["2"] = state} = Regex.check(content1, config, :initial)

    assert {:change_detected, new_state} = Regex.check(content2, config, state)
    assert new_state == ["4"]
  end

  test "non-match without change" do
    content1 = "first"
    content2 = "second"
    config = config("(\\d)")
    {:change_detected, nil = state} = Regex.check(content1, config, :initial)

    assert {:no_change, new_state} = Regex.check(content2, config, state)
    assert new_state == nil
  end

  test "non-match with change" do
    content1 = "match 4 me"
    content2 = "match"
    config = config("(\\d)")
    {:change_detected, ["4"] = state} = Regex.check(content1, config, :initial)

    assert {:change_detected, new_state} = Regex.check(content2, config, state)
    assert new_state == nil
  end

  test "invalid regex" do
    assert {:error, {:invalid_regex, _}} =
             Regex.check("content", config("invalid ( regex"), :initial)
  end

  defp config(regex) do
    %{"regex" => regex}
  end
end
