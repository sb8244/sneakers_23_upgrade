#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Test.Factory.InventoryFactory do
  alias Test.Factory.{ItemFactory, ItemAvailabilityFactory, ProductFactory}
  alias Sneakers23.Inventory.{Inventory}

  def complete_products() do
    p1 = ProductFactory.create!(%{sku: "p1", order: 1})
    p2 = ProductFactory.create!(%{sku: "p2", order: 0})
    i1 = ItemFactory.create!(%{sku: "i1", product_id: p1.id})
    i2 = ItemFactory.create!(%{sku: "i2", product_id: p1.id})
    i3 = ItemFactory.create!(%{sku: "i3", product_id: p2.id})
    ia1 =
      ItemAvailabilityFactory.create!(%{item_id: i1.id, available_count: 1})
    ia2 =
      ItemAvailabilityFactory.create!(%{item_id: i2.id, available_count: 2})
    ia3 =
      ItemAvailabilityFactory.create!(%{item_id: i3.id, available_count: 3})
    data = %{
      p1: p1, p2: p2,
      i1: i1, i2: i2, i3: i3,
      ia1: ia1, ia2: ia2, ia3: ia3
    }

    inventory =
      Inventory.new()
      |> Inventory.add_products([p1, p2])
      |> Inventory.add_items([i1, i2, i3])
      |> Inventory.add_availabilities([ia1, ia2, ia3])

    {inventory, data}
  end
end
