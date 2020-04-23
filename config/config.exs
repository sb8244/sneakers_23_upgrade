#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sneakers_23,
  namespace: Sneakers23,
  ecto_repos: [Sneakers23.Repo]

# Configures the endpoint
config :sneakers_23, Sneakers23Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/pQ3LrKcYNFtUJQ5XQBobICQGWUFohT3O6yuz+76ZuzA2khRwvIBpFJx6BTeFTZ/",
  render_errors: [view: Sneakers23Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sneakers23.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
