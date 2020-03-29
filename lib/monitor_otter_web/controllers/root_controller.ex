defmodule MonitorOtterWeb.RootController do
  use MonitorOtterWeb, :controller
  alias MonitorOtter.DAO.Jobs

  def index(conn, _params) do
    if conn.assigns.authenticated? do
      jobs =
        conn.assigns.auth_user
        |> Jobs.get_all_by_user()
        |> Enum.filter(& &1.enabled)

      render(conn, "index.html", %{jobs: jobs})
    else
      render(conn, "index.html")
    end
  end
end
