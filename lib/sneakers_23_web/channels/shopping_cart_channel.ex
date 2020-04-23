#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.ShoppingCartChannel do
  use Phoenix.Channel

  alias Sneakers23.Checkout

  import Sneakers23Web.CartView, only: [cart_to_map: 1]

  intercept ["cart_updated"]

  def join("cart:" <> id, params, socket) when byte_size(id) == 64 do
    cart = get_cart(params)
    socket = assign(socket, :cart, cart)
    send(self(), :send_cart)
    enqueue_cart_subscriptions(cart)

    socket = socket
      |> assign(:cart_id, id)
      |> assign(:page, Map.get(params, "page", nil))

    send(self(), :after_join)

    {:ok, socket}
  end

  def handle_info(:after_join, socket = %{
    assigns: %{cart: cart, cart_id: id, page: page}
  }) do
    {:ok, _} = Sneakers23Web.CartTracker.track_cart(
      socket, %{cart: cart, id: id, page: page}
    )
    {:noreply, socket}
  end

  def handle_info(:update_tracked_cart, socket = %{
    assigns: %{cart: cart, cart_id: id}
  }) do
    {:ok, _} = Sneakers23Web.CartTracker.update_cart(
      socket, %{cart: cart, id: id}
    )
    {:noreply, socket}
  end

  def handle_info(:send_cart, socket = %{assigns: %{cart: cart}}) do
    push(socket, "cart", cart_to_map(cart))
    {:noreply, socket}
  end

  def handle_info({:item_out, _id}, socket = %{assigns: %{cart: cart}}) do
    push(socket, "cart", cart_to_map(cart))
    {:noreply, socket}
  end

  def handle_info({:subscribe, item_id}, socket) do
    Phoenix.PubSub.subscribe(Sneakers23.PubSub, "item_out:#{item_id}")
    {:noreply, socket}
  end

  def handle_info({:unsubscribe, item_id}, socket) do
    Phoenix.PubSub.unsubscribe(Sneakers23.PubSub, "item_out:#{item_id}")
    {:noreply, socket}
  end

  def handle_in(
    "add_item", %{"item_id" => id}, socket = %{assigns: %{cart: cart}}) do
    case Checkout.add_item_to_cart(cart, String.to_integer(id)) do
      {:ok, new_cart} ->
        send(self(), {:subscribe, id})
        broadcast_cart(new_cart, socket, added: [id])
        socket = assign(socket, :cart, new_cart)
        {:reply, {:ok, cart_to_map(new_cart)}, socket}

      {:error, :duplicate_item} ->
        {:reply, {:error, %{error: "duplicate_item"}}, socket}
    end
  end

  def handle_in(
    "remove_item", %{"item_id" => id}, socket = %{assigns: %{cart: cart}}) do
    case Checkout.remove_item_from_cart(cart, String.to_integer(id)) do
      {:ok, new_cart} ->
        send(self(), {:unsubscribe, id})
        broadcast_cart(new_cart, socket, removed: [id])
        socket = assign(socket, :cart, new_cart)
        {:reply, {:ok, cart_to_map(new_cart)}, socket}

      {:error, :not_found} ->
        {:reply, {:error, %{error: "not_found"}}, socket}
    end
  end

  def handle_out("cart_updated", params, socket) do
    modify_subscriptions(params)
    cart = get_cart(params)
    socket = assign(socket, :cart, cart)
    push(socket, "cart", cart_to_map(cart))
    send(self(), :update_tracked_cart)

    {:noreply, socket}
  end

  defp broadcast_cart(cart, socket, opts) do
    send(self(), :update_tracked_cart)
    {:ok, serialized} = Checkout.export_cart(cart)

    broadcast_from(socket, "cart_updated", %{
      "serialized" => serialized,
      "added" => Keyword.get(opts, :added, []),
      "removed" => Keyword.get(opts, :removed, [])
    })
  end

  defp get_cart(params) do
    params
    |> Map.get("serialized", nil)
    |> Checkout.restore_cart()
  end

  defp enqueue_cart_subscriptions(cart) do
    cart
    |> Checkout.cart_item_ids()
    |> Enum.each(fn id ->
      send(self(), {:subscribe, id})
    end)
  end

  defp modify_subscriptions(%{"added" => add, "removed" => remove}) do
    Enum.each(add, & send(self(), {:subscribe, &1}))
    Enum.each(remove, & send(self(), {:unsubscribe, &1}))
  end
end
