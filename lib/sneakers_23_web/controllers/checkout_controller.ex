#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.CheckoutController do
  use Sneakers23Web, :controller

  def show(conn, %{"serialized_cart" => serialized_cart}) do
    cart = cart(serialized_cart)
    %{items: items} = Sneakers23Web.CartView.cart_to_map(cart)

    case items do
      [] ->
        render(conn, "empty.html")

      items ->
        conn
        |> assign(:items, items)
        |> assign(:serialized_cart, serialized_cart)
        |> assign(:cant_purchase?, cant_purchase?(items))
        |> render("show.html")
    end
  end

  def show(conn, _params), do: redirect(conn, to: Routes.product_path(conn, :index))

  def purchase(conn, params) do
    with serialized_cart <- Map.get(params, "serialized_cart"),
         cart <- cart(serialized_cart),
         %{items: items} when items != [] <- Sneakers23Web.CartView.cart_to_map(cart),
         {:availability, false} <- {:availability, has_out_of_stock_items?(items)},
         {:released, false} <- {:released, has_unreleased_items?(items)},
         {:purchase, {:ok, _}} <- {:purchase, Sneakers23.Checkout.purchase_cart(cart)} do
      redirect(conn, to: Routes.checkout_path(conn, :success))
    else
      %{items: []} ->
        conn
        |> put_flash(:error, "Your cart is empty")
        |> redirect(to: Routes.checkout_path(conn, :show, params))

      {:availability, true} ->
        conn
        |> put_flash(:error, "Your cart has out-of-stock shoes")
        |> redirect(to: Routes.checkout_path(conn, :show, params))

      {:released, true} ->
        conn
        |> put_flash(:error, "Your cart has unreleased shoes")
        |> redirect(to: Routes.checkout_path(conn, :show, params))

      {:purchase, _} ->
        conn
        |> put_flash(:error, "Your purchase could not be completed")
        |> redirect(to: Routes.checkout_path(conn, :show, params))
    end
  end

  def success(conn, _params) do
    conn
    |> render("success.html")
  end

  defp cart(serialized) do
    Sneakers23.Checkout.restore_cart(serialized)
  end

  defp cant_purchase?(items), do: has_out_of_stock_items?(items) || has_unreleased_items?(items)

  defp has_out_of_stock_items?(items), do: Enum.any?(items, & &1.out_of_stock)

  defp has_unreleased_items?(items), do: Enum.any?(items, &(!&1.released))
end
