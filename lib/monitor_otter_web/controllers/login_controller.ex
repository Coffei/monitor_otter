defmodule MonitorOtterWeb.LoginController do
  use MonitorOtterWeb, :controller
  alias MonitorOtter.DAO.Users

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, params) do
    if Users.check_password(params["email"], params["password"]) do
      conn
      |> put_session("auth_user", params["email"])
      |> configure_session(renew: true)
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Bad email/password combination.")
      |> assign(:email, params["email"])
      |> render("index.html")
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
