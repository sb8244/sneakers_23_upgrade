#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.Router do
  use Sneakers23Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Sneakers23Web.CartIdPlug
  end

  scope "/", Sneakers23Web do
    pipe_through :browser

    get "/", ProductController, :index
    get "/checkout", CheckoutController, :show
    post "/checkout", CheckoutController, :purchase
    get "/checkout/complete", CheckoutController, :success
  end

  pipeline :admin do
    plug BasicAuth, use_config: {:sneakers_23, :admin_auth}
    plug :put_layout, {Sneakers23Web.LayoutView, :admin}
  end

  scope "/admin", Sneakers23Web.Admin do
    pipe_through [:browser, :admin]

    get "/", DashboardController, :index
  end
end
