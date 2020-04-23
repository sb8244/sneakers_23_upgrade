#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.InventoryTest do
  use Sneakers23.DataCase, async: false
  alias Sneakers23.Inventory
  alias Inventory.{DatabaseLoader, Product, Server}

  describe "mark_product_released!/2" do
    def product_release_status(product, pid: pid) do
      {:ok, %{products: products}} = Server.get_inventory(pid)

      {
        products |> Map.get(product.id) |> Map.get(:released),
        Repo.get!(Product, product.id) |> Map.get(:released)
      }
    end

    test "the update is received locally", %{test: test_name} do
      {_, %{p1: p1}} = Test.Factory.InventoryFactory.complete_products()
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: DatabaseLoader)
      Sneakers23Web.Endpoint.subscribe("product:#{p1.id}")

      assert product_release_status(p1, pid: pid) == {false, false}
      Inventory.mark_product_released!(p1.id, pid: pid)
      assert product_release_status(p1, pid: pid) == {true, true}
    end

    test "the update is sent to the client", %{test: test_name} do
      {_, %{p1: p1}} = Test.Factory.InventoryFactory.complete_products()
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: DatabaseLoader)
      Sneakers23Web.Endpoint.subscribe("product:#{p1.id}")

      Inventory.mark_product_released!(p1.id, pid: pid)
      assert_received %Phoenix.Socket.Broadcast{event: "released"}
    end
  end
end
