#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.ProductChannelTest do
  use Sneakers23Web.ChannelCase, async: true
  alias Sneakers23Web.{Endpoint, ProductChannel}
  alias Sneakers23.Inventory.CompleteProduct

  describe "notify_product_released/1" do
    test "the size selector for the product is broadcast" do
      {inventory, _data} = Test.Factory.InventoryFactory.complete_products()
      [_, product] = CompleteProduct.get_complete_products(inventory)

      topic = "product:#{product.id}"
      Endpoint.subscribe(topic)
      ProductChannel.notify_product_released(product)

      assert_broadcast "released", %{size_html: html}
      assert html =~ "size-container__entry"
      Enum.each(product.items, fn item ->
        assert html =~ ~s(value="#{item.id}")
      end)
    end
  end

  describe "notify_item_stock_change/1" do
    setup _ do
      {inventory, _data} =
        Test.Factory.InventoryFactory.complete_products()

      [product = %{items: [item]}, _] =
        CompleteProduct.get_complete_products(inventory)

      topic = "product:#{product.id}"
      Endpoint.subscribe(topic)

      {:ok, %{product: product, item: item}}
    end

    test "the same stock level doesn't broadcast an event", %{item: item} do
      opts = [previous_item: item, current_item: item]
      assert ProductChannel.notify_item_stock_change(opts)
        == {:ok, :no_change}

      refute_broadcast "stock_change", _
    end

    test "a stock level change broadcasts an event",
      %{item: item, product: product} do
      new_item = Map.put(item, :available_count, 0)
      opts = [previous_item: item, current_item: new_item]
      assert ProductChannel.notify_item_stock_change(opts)
        == {:ok, :broadcast}

      payload = %{item_id: item.id, product_id: product.id, level: "out"}
      assert_broadcast "stock_change", ^payload
    end
  end
end
