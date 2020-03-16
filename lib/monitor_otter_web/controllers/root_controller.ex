defmodule MonitorOtterWeb.RootController do
  use MonitorOtterWeb, :controller
  alias MonitorOtter.DAO.Jobs

  def index(conn, _params) do
    jobs =
      Jobs.get_all()
      |> Enum.sort_by(& &1.id)

    render(conn, "index.html", %{jobs: jobs})
  end
end
