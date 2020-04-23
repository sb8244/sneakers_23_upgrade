#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.CompleteProductTest do
  use Sneakers23.DataCase, async: true

  alias Sneakers23.Inventory.{CompleteProduct}

  describe "get_complete_products/1" do
    test "the products, items, and availability are stitched together" do
      {inventory, data} = Test.Factory.InventoryFactory.complete_products()
      products = CompleteProduct.get_complete_products(inventory)

      assert [first, second] = products
      assert {first.id, first.sku} == {data.p2.id, data.p2.sku}
      assert {second.id, second.sku} == {data.p1.id, data.p1.sku}
      assert Enum.map(first.items, & {&1.id, &1.available_count}) == [
        {data.i3.id, data.ia3.available_count}
      ]

      assert Enum.map(second.items, & {&1.id, &1.available_count}) == [
        {data.i1.id, data.ia1.available_count},
        {data.i2.id, data.ia2.available_count}
      ]
    end
  end
end
