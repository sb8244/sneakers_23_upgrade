/***
 * Excerpted from "Real-Time Phoenix",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
***/
const Cart = {}
export default Cart

Cart.setupCartChannel = (socket, cartId, { onCartChange }) => {
  const cartChannel = socket.channel(`cart:${cartId}`, channelParams)
  const onCartChangeFn = (cart) => {
    console.debug("Cart received", cart)
    localStorage.storedCart = cart.serialized
    onCartChange(cart)
  }

  cartChannel.on("cart", onCartChangeFn)
  cartChannel.join().receive("error", () => {
    console.error("Cart join failed")
  })

  return {
    cartChannel,
    onCartChange: onCartChangeFn
  }
}

function channelParams() {
  return {
    serialized: localStorage.storedCart,
    page: window.location.pathname
  }
}

Cart.addCartItem = ({ cartChannel, onCartChange }, itemId) => {
  cartRequest(cartChannel, "add_item", { item_id: itemId }, (resp) => {
    onCartChange(resp)
  })
}

Cart.removeCartItem = ({ cartChannel, onCartChange }, itemId) => {
  cartRequest(cartChannel, "remove_item", { item_id: itemId }, (resp) => {
    onCartChange(resp)
  })
}

function cartRequest(cartChannel, event, payload, onSuccess) {
  cartChannel.push(event, payload)
    .receive("ok", onSuccess)
    .receive("error", (resp) => console.error("Cart error", event, resp))
    .receive("timeout", () => console.error("Cart timeout", event))
}
