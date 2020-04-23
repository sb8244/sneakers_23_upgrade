#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Checkout.SingleItem do
  alias Sneakers23.Inventory
  alias Inventory.Store

  def sell_item(item_id, opts \\ []) do
    inventory_opts = Keyword.get(opts, :inventory_opts, [])

    with {:db, :ok} <- {:db, Store.reduce_availability(item_id)} do
      unless Keyword.get(opts, :skip_replication, false) do
        Task.start_link(fn -> Inventory.item_sold!(item_id, inventory_opts) end)
      end

      :ok
    else
      {:db, e = {:error, _}} ->
        e
    end
  end
end
