defmodule Magnetissimo.Router do
  use Magnetissimo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :exq do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/exq", ExqUi do
    pipe_through :exq
    forward "/", RouterPlug.Router, :index
  end

  scope "/", Magnetissimo do
    pipe_through :browser # Use the default browser stack

    get "/", TorrentController, :index
    get "/summary", TorrentController, :summary
  end

  # Other scopes may use custom stacks.
  # scope "/api", Magnetissimo do
  #   pipe_through :api
  # end
end
