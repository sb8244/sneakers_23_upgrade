#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.DatabaseLoader do
  alias Sneakers23.Inventory.{Inventory, Store}

  def load() do
    inventory =
      Inventory.new()
      |> Inventory.add_products(Store.all_products())
      |> Inventory.add_items(Store.all_items())
      |> Inventory.add_availabilities(Store.all_item_availabilities())

    {:ok, inventory}
  end
end
