#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.CartTracker do
  use Phoenix.Presence, otp_app: :sneakers_23,
                        pubsub_server: Sneakers23.PubSub
  @topic "admin:cart_tracker"

  def track_cart(socket, %{cart: cart, id: id, page: page}) do
    track(socket.channel_pid, @topic, id, %{
      page_loaded_at: System.system_time(:millisecond),
      page: page,
      items: Sneakers23.Checkout.cart_item_ids(cart)
    })
  end

  def all_carts(), do: list(@topic)

  def update_cart(socket, %{cart: cart, id: id}) do
    update(socket.channel_pid, @topic, id, fn existing_meta ->
      Map.put(existing_meta, :items, Sneakers23.Checkout.cart_item_ids(cart))
    end)
  end
end
