defmodule MonitorOtterWeb.LoginController do
  use MonitorOtterWeb, :controller
  alias MonitorOtter.DAO.Users

  def index(conn, _params) do
    redirect_to = conn.query_params["redirect_to"] || Routes.root_path(conn, :index)
    render(conn, "index.html", %{redirect_to: redirect_to})
  end

  def login(conn, params) do
    if Users.check_password(params["email"], params["password"]) do
      redirect_to = conn.params["redirect_to"]

      conn
      |> put_session("auth_user", params["email"])
      |> configure_session(renew: true)
      |> redirect(to: redirect_to)
    else
      conn
      |> put_flash(:error, "Bad email/password combination.")
      |> assign(:email, params["email"])
      |> render("index.html", %{redirect_to: conn.params["redirect_to"]})
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
