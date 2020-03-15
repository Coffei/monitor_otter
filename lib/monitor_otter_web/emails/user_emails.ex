defmodule MonitorOtterWeb.UserEmail do
  use Phoenix.Swoosh,
    view: MonitorOtterWeb.EmailView,
    layout: {MonitorOtterWeb.LayoutView, :email}

  alias MonitorOtter.Models.Job

  def change_detected(%Job{name: name, notification_email: email} = job, previous_state) do
    from = Application.get_env(:monitor_otter, MonitorOtterWeb.Mailer)[:from]

    new()
    |> from(from)
    |> to(email)
    |> subject("Change detected - #{name}")
    |> render_body("change_detected.html", %{job: job, previous_state: previous_state})
  end
end
