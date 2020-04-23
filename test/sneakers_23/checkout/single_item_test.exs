#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Checkout.SingleItemTest do
  use Sneakers23.DataCase, async: false
  alias Sneakers23.Checkout.SingleItem
  alias Sneakers23.Inventory.{DatabaseLoader, Inventory, Server, Store}

  def get_item_counts(item, pid) do
    {:ok, inv} = Server.get_inventory(pid)

    {
      Inventory.get_availability_for_item(inv, item).available_count,
      Store.fetch_availability_for_item(item.id).available_count
    }
  end

  test "an item is sold if available", %{test: test_name} do
    {_, %{i1: i1}} = Test.Factory.InventoryFactory.complete_products()
    {:ok, pid} = Server.start_link(name: test_name, loader_mod: DatabaseLoader)
    Sneakers23Web.Endpoint.subscribe("product:#{i1.product_id}")

    assert get_item_counts(i1, pid) == {1, 1}

    opts = [inventory_opts: [pid: pid]]
    assert SingleItem.sell_item(i1.id, opts) == :ok
    Process.sleep(50)
    assert get_item_counts(i1, pid) == {0, 0}

    assert SingleItem.sell_item(i1.id, opts) == {:error, :not_available}
    Process.sleep(50)
    assert get_item_counts(i1, pid) == {0, 0}
  end
end
