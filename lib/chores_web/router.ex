defmodule ChoresWeb.Router do
  use ChoresWeb, :router
  import ChoresWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
  end

  scope "/", ChoresWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # public api routes
  scope "/api", ChoresWeb do
    pipe_through :api

    post "/auth/register", UserController, :register
    post "/auth/login", UserController, :login
  end

  # restricted api routes
  scope "/api", ChoresWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/loginCheck", UserController, :test
    resources "/activities", ActivityController, except: [:new, :edit]
    resources "/tags", TagController, except: [:new, :edit]
    delete "/auth/logout", UserController, :logout
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ChoresWeb.Telemetry
    end
  end
end
