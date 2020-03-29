defmodule MonitorOtterWeb.JobView do
  use MonitorOtterWeb, :view

  def format_ts(%DateTime{} = time, _default) do
    time
    |> Timex.Timezone.convert("Europe/Prague")
    |> Timex.format!("{D}.{M}.{YYYY} {h24}:{m}")
  end

  def format_ts(_, default), do: default

  def hostname(url) do
    regex = ~r/^.+:\/\/([^\/?#]+)/

    case Regex.run(regex, url) do
      [_, hostname] -> hostname
      _ -> url
    end
  end
end
