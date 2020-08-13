defmodule StoneChallengeWeb.Router do
  use StoneChallengeWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_root_layout, {StoneChallengeWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", StoneChallengeWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Define pipeline for authenticate routes
  pipeline :authenticate do
    plug :accepts, ["json"]
    plug StoneChallengeWeb.Plugs.Authenticate
  end

  # Define pipeline for public routes
  pipeline :public do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", StoneChallengeWeb do
    pipe_through :public
    post "/sessions", SessionController, :create
    post "/users", UserController, :create

    pipe_through :authenticate
    post "/transactions", TransactionController, :create
    delete "/sessions", SessionController, :delete
    resources "/users", UserController, only: [:index, :show]
    resources "/reports", ReportsController, only: [:index]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: StoneChallengeWeb.Telemetry
  #   end
  # end
end
