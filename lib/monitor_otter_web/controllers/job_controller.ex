defmodule MonitorOtterWeb.JobController do
  use MonitorOtterWeb, :controller
  alias MonitorOtter.DAO.Jobs

  def index(conn, _params) do
    jobs = Jobs.get_all_by_user(conn.assigns.auth_user)
    render(conn, "index.html", %{jobs: jobs})
  end
end
