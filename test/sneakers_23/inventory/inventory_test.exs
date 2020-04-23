#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.InventoryTest do
  use ExUnit.Case, async: true
  alias Sneakers23.Inventory.{Inventory, Item, ItemAvailability, Product}

  def assert_inventory(inventory, type, expected) do
    assert Map.get(inventory, type) == expected
    inventory
  end

  describe "add_product/2" do
    test "products can be added" do
      product = %Product{id: 1, sku: "test"}
      product2 = %Product{id: 2, sku: "test2"}

      Inventory.new()
      |> Inventory.add_products([product])
      |> assert_inventory(:products, %{1 => product})
      |> Inventory.add_products([product2])
      |> assert_inventory(:products, %{1 => product, 2 => product2})
    end
  end

  describe "add_item/2" do
    test "products can be added" do
      item = %Item{id: 1, sku: "test"}
      item2 = %Item{id: 2, sku: "test2"}

      Inventory.new()
      |> Inventory.add_items([item])
      |> assert_inventory(:items, %{1 => item})
      |> Inventory.add_items([item2])
      |> assert_inventory(:items, %{1 => item, 2 => item2})
    end
  end

  describe "add_availability/2" do
    test "products can be added" do
      availability = %ItemAvailability{id: 1, available_count: 0}
      availability2 = %ItemAvailability{id: 2, available_count: 1}

      Inventory.new()
      |> Inventory.add_availabilities([availability])
      |> assert_inventory(:availability, %{1 => availability})
      |> Inventory.add_availabilities([availability2])
      |> assert_inventory(:availability, %{1 => availability, 2 => availability2})
    end
  end
end
