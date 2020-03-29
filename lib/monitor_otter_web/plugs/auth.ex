defmodule MonitorOtterWeb.Plugs.Auth do
  @behaviour Plug
  import Plug.Conn
  alias MonitorOtter.DAO.Users
  alias MonitorOtter.Models.User

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, _opts) do
    auth_email =
      conn
      |> get_session("auth_user")

    with email when not is_nil(email) <- auth_email,
         %User{} = user <- Users.get_by_email(email) do
      conn
      |> merge_assigns(authenticated?: true, auth_user: user)
    else
      _ ->
        conn
        |> assign(:authenticated?, false)
    end
  end
end
