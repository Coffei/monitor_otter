defmodule MonitorOtterWeb.Plugs.EnsureAuth do
  @behaviour Plug
  import Phoenix.Controller
  alias MonitorOtterWeb.Router.Helpers, as: Routes

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, _opts) do
    if conn.assigns.authenticated? do
      conn
    else
      conn
      |> put_flash(:warning, "You must log in first.")
      |> redirect(to: Routes.login_path(conn, :index, redirect_to: conn.request_path))
    end
  end
end
