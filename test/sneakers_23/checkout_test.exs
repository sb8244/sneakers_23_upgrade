#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.CheckoutTest do
  use Sneakers23.DataCase, async: true

  alias Sneakers23.Checkout
  alias Checkout.ShoppingCart

  describe "restore_cart/1" do
    test "nil gives a new cart" do
      assert Checkout.restore_cart(nil) == ShoppingCart.new()
    end

    test "a valid cart will be returned" do
      cart = ShoppingCart.new()
      assert {:ok, cart} = ShoppingCart.add_item(cart, 1)
      assert {:ok, serialized} = Checkout.export_cart(cart)
      assert Checkout.restore_cart(serialized) == cart
    end

    test "an invalid cart returns a new cart" do
      assert Checkout.restore_cart("nope") == ShoppingCart.new()
    end
  end

  describe "add_item_to_cart/2" do
    test "any item can be added once (including out-of-stock)" do
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, 1)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, 2)
      assert Checkout.add_item_to_cart(cart, 1) == {:error, :duplicate_item}
    end
  end

  describe "remove_item_from_cart/2" do
    test "any in-cart item can be removed" do
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, 1)
      assert {:ok, cart} = Checkout.remove_item_from_cart(cart, 1)
      assert Checkout.remove_item_from_cart(cart, 1) == {:error, :not_found}
    end
  end

  describe "cart_item_ids/1" do
    cart = Checkout.restore_cart(nil)
    assert {:ok, cart} = Checkout.add_item_to_cart(cart, 1)
    assert {:ok, cart} = Checkout.add_item_to_cart(cart, 2)
    assert Checkout.cart_item_ids(cart) == [2, 1]
  end

  describe "generate_cart_id/0" do
    test "a 64 length string is returned" do
      id = Checkout.generate_cart_id()
      assert byte_size(id) == 64
    end
  end

  describe "purchase_cart/1" do
    test "an invalid purchase returns an error" do
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, 1)

      assert Checkout.purchase_cart(cart) == {:error, :purchase_failed}
      Process.sleep(50) # purge async
    end

    test "no availability returns an error" do
      {_, %{i1: i1}} = Test.Factory.InventoryFactory.complete_products()
      assert Checkout.SingleItem.sell_item(i1.id, skip_replication: true) == :ok
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, i1.id)

      assert Checkout.purchase_cart(cart) == {:error, :purchase_failed}
      Process.sleep(50) # purge async
    end

    test "a valid item can be purchased" do
      {_, %{i1: i1}} = Test.Factory.InventoryFactory.complete_products()
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, i1.id)

      assert Checkout.purchase_cart(cart, skip_replication: true) == {:ok, :purchase_complete}
      Process.sleep(50) # purge async
    end

    test "multiple items can be purchased" do
      {_, %{i1: i1, i2: i2}} = Test.Factory.InventoryFactory.complete_products()
      cart = Checkout.restore_cart(nil)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, i1.id)
      assert {:ok, cart} = Checkout.add_item_to_cart(cart, i2.id)

      assert Checkout.purchase_cart(cart, skip_replication: true) == {:ok, :purchase_complete}
      Process.sleep(50) # purge async
    end
  end
end
