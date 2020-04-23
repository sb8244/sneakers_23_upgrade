#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Sneakers23.Repo,
      Sneakers23Web.Endpoint,
      {Sneakers23Web.CartTracker,
        [pool_size: :erlang.system_info(:schedulers_online)]},
      Sneakers23.Inventory,
      Sneakers23.Replication,
    ]

    opts = [strategy: :one_for_one, name: Sneakers23.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Sneakers23Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
