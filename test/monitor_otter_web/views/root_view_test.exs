defmodule MonitorOtterWeb.RootViewTest do
  use MonitorOtterWeb.ConnCase, async: true
  alias MonitorOtterWeb.RootView

  test "time is formatted properly" do
    assert RootView.format_ts(~U[2020-03-20T12:54:12Z]) == "20.3.2020 13:54"
  end

  test "extract hostname from url" do
    addresses = [
      "http://test.cz",
      "http://test.cz/some/path",
      "http://test.cz#handle",
      "http://test.cz?query-params=true",
      "some.different_protocol://test.cz"
    ]

    for address <- addresses do
      assert RootView.hostname(address) == "test.cz"
    end
  end
end
