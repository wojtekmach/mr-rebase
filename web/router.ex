defmodule MrRebase.Router do
  use MrRebase.Web, :router
  use Honeybadger.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MrRebase do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/repos/:user/:repo", PageController, :repo
    post "/repos/:user/:repo/:ref/rebase", PageController, :rebase
    get "/error", PageController, :error
  end

  scope "/auth", MrRebase do
    pipe_through :browser

    get "/", AuthController, :index
    delete "/", AuthController, :delete
    get "/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", MrRebase do
  #   pipe_through :api
  # end
end
