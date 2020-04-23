#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.CheckoutControllerTest do
  use Sneakers23Web.ConnCase, async: false

  alias Sneakers23.{Checkout, Inventory}

  setup ctx do
    {inventory, data} = Test.Factory.InventoryFactory.complete_products()
    {:ok, _} = GenServer.call(Inventory, {:test_set_inventory, inventory})

    if Map.get(ctx, :released, true) do
      Inventory.mark_product_released!(data.p1.id)
      Inventory.mark_product_released!(data.p2.id)
    end

    cart = Checkout.restore_cart(nil)
    {:ok, cart} = Checkout.add_item_to_cart(cart, data.i1.id)
    {:ok, cart} = Checkout.add_item_to_cart(cart, data.i2.id)
    {:ok, serialized} = Checkout.export_cart(cart)

    {:ok, %{cart: cart, serialized: serialized}}
  end

  describe "GET /checkout" do
    test "requires a 'serialized_cart' parameter", %{conn: conn} do
      conn = get(conn, "/checkout")
      assert redirected_to(conn) == "/"
    end

    test "an invalid / empty cart shows a message", %{conn: conn} do
      conn = get(conn, "/checkout", %{serialized_cart: "invalid"})
      assert response(conn, 200) =~ "No items to checkout!"
    end

    test "a cart with in-stock items shows each item", %{conn: conn, cart: cart, serialized: serialized} do
      [id2, id1] = Checkout.cart_item_ids(cart)

      conn = get(conn, "/checkout", %{serialized_cart: serialized})
      assert response(conn, 200) =~ ~s(data\-item\-id="#{id1}")
      assert response(conn, 200) =~ ~s(data\-item\-id="#{id2}")
      refute response(conn, 200) =~ ~s(data\-item\-id="#{id2+1}")
      refute response(conn, 200) =~ "Sorry, this shoe is sold out"
      refute response(conn, 200) =~ "SOME ITEMS NOT AVAILABLE"
    end

    test "a cart with out-of-stock items disables checkout", %{conn: conn, cart: cart, serialized: serialized} do
      [id2, id1] = Checkout.cart_item_ids(cart)
      Checkout.SingleItem.sell_item(id1) # this item is now out-of-stock
      Process.sleep(50) # Wait for SingleItem Task to finish

      conn = get(conn, "/checkout", %{serialized_cart: serialized})
      assert response(conn, 200) =~ ~s(data\-item\-id="#{id1}")
      assert response(conn, 200) =~ ~s(data\-item\-id="#{id2}")
      assert response(conn, 200) =~ "Sorry, this shoe is sold out"
      assert response(conn, 200) =~ "SOME ITEMS NOT AVAILABLE"
    end
  end

  describe "POST /checkout" do
    test "an invalid / empty cart redirects to /checkout", %{conn: conn} do
      conn = post(conn, "/checkout", %{})

      assert redirected_to(conn) == "/checkout"
      assert get_flash(conn) == %{"error" => "Your cart is empty"}
    end

    test "a cart with out-of-stock redirects with an error", %{conn: conn, cart: cart, serialized: serialized} do
      [_id2, id1] = Checkout.cart_item_ids(cart)
      Checkout.SingleItem.sell_item(id1) # this item is now out-of-stock
      Process.sleep(50) # Wait for SingleItem Task to finish

      conn = post(conn, "/checkout", %{"serialized_cart" => serialized})

      assert redirected_to(conn) =~ "/checkout?serialized_cart="
      assert get_flash(conn) == %{"error" => "Your cart has out-of-stock shoes"}
    end

    @tag released: false
    test "a cart with unreleased shoes redirects with an error", %{conn: conn, serialized: serialized} do
      conn = post(conn, "/checkout", %{"serialized_cart" => serialized})

      assert redirected_to(conn) =~ "/checkout?serialized_cart="
      assert get_flash(conn) == %{"error" => "Your cart has unreleased shoes"}
    end

    test "a valid cart is purchased", %{conn: conn, cart: cart, serialized: serialized} do
      originals =
        cart
        |> Checkout.cart_item_ids()
        |> Enum.map(& {&1, Inventory.Store.fetch_availability_for_item(&1).available_count})

      conn = post(conn, "/checkout", %{"serialized_cart" => serialized})

      assert redirected_to(conn) =~ "/checkout/complete"

      Enum.each(originals, fn {id, count} ->
        new_count = Inventory.Store.fetch_availability_for_item(id).available_count
        assert new_count == count - 1
      end)

      Process.sleep(100) # flush all async tasks that use the database
    end
  end
end
