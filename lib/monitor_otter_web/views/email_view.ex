defmodule MonitorOtterWeb.EmailView do
  use MonitorOtterWeb, :view

  def format_date(datetime) do
    datetime
    |> Timex.Timezone.convert("Europe/Prague")
    |> Timex.format!("{D}.{M}.{YYYY} {h24}:{m}")
  end
end
