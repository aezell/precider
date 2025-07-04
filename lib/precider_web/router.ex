defmodule PreciderWeb.Router do
  use PreciderWeb, :router

  import PreciderWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PreciderWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Health check endpoint (no authentication required)
  scope "/", PreciderWeb do
    pipe_through :api

    get "/health", HealthController, :check
  end

  scope "/", PreciderWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/product_finder", ProductFinderLive.Index, :index
    live "/pre_chooser", PreChooserLive.Index, :index
    live "/pre_chooser/results", PreChooserLive.Index, :results
    live "/compare", ProductComparisonLive.Index, :index
    live "/product_detail/:id", ProductDetailLive.Index, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:precider, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/", PreciderWeb do
      pipe_through :browser

      resources "/brands", BrandController
      post "/brands/:id/toggle_completed", BrandController, :toggle_completed
      get "/products/new/open_ingredient_modal", ProductController, :open_ingredient_modal
      resources "/products", ProductController
      resources "/ingredients", IngredientController
      resources "/product_ingredients", ProductIngredientController
    end

    scope "/api", PreciderWeb do
      pipe_through :api

      post "/products/new/create_ingredient", ProductController, :create_ingredient
    end

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PreciderWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PreciderWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PreciderWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", PreciderWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{PreciderWeb.UserAuth, :mount_current_scope}] do
      # live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
