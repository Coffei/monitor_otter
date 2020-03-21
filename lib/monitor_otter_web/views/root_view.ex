defmodule MonitorOtterWeb.RootView do
  use MonitorOtterWeb, :view

  def format_ts(%DateTime{} = time, _default) do
    time
    |> Timex.Timezone.convert("Europe/Prague")
    |> Timex.format!("{D}.{M}.{YYYY} {h24}:{m}")
  end

  def format_ts(_, default), do: default

  def hostname(url) do
    regex = ~r/^.+:\/\/([^\/?#]+)/
    [_, hostname] = Regex.run(regex, url)
    hostname
  end
end
