defmodule MonitorOtter.Mocks.Http do
  def fetch("http://simple-" <> rest) do
    [_, content] = Regex.run(~r/(.*).com$/, rest)
    {:ok, content}
  end

  def fetch(_) do
    {:error, :unknown_url}
  end
end
