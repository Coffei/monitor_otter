defmodule MonitorOtterWeb.RootView do
  use MonitorOtterWeb, :view

  def format_ts(time) do
    time
    |> Timex.Timezone.convert("Europe/Prague")
    |> Timex.format!("{D}.{M}.{YYYY} {h24}:{m}")
  end

  def hostname(url) do
    regex = ~r/^.+:\/\/([^\/?#]+)/
    [_, hostname] = Regex.run(regex, url)
    hostname
  end
end
