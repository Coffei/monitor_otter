defmodule MonitorOtterWeb.Router do
  use MonitorOtterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MonitorOtterWeb.Plugs.Auth
  end

  pipeline :authenticated do
    plug MonitorOtterWeb.Plugs.EnsureAuth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MonitorOtterWeb do
    pipe_through :browser

    get "/", RootController, :index
    get "/login", LoginController, :index
    post "/login", LoginController, :login
    delete "/logout", LoginController, :logout

    scope "/user" do
      pipe_through :authenticated
      get "/jobs", JobController, :index
    end
  end
end
