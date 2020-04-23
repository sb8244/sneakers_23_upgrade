/***
 * Excerpted from "Real-Time Phoenix",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
***/
import css from "../css/app.css"
import { productSocket } from "./socket"
import dom from './dom'
import Cart from './cart'

productSocket.connect()

const productIds = dom.getProductIds()

productIds.forEach((id) => setupProductChannel(productSocket, id))

const cartChannel = Cart.setupCartChannel(productSocket, window.cartId, {
  onCartChange: (newCart) => {
    dom.renderCartHtml(newCart)
  }
})

dom.onItemClick((itemId) => {
  Cart.addCartItem(cartChannel, itemId)
})

dom.onItemRemoveClick((itemId) => {
  Cart.removeCartItem(cartChannel, itemId)
})

function setupProductChannel(socket, productId) {
  const productChannel = socket.channel(`product:${productId}`)
  productChannel.join()
    .receive("error", () => {
      console.error("Channel join failed")
    })

  productChannel.on('released', ({ size_html }) => {
    dom.replaceProductComingSoon(productId, size_html)
  })

  productChannel.on('stock_change', ({ product_id, item_id, level }) => {
    dom.updateItemLevel(item_id, level)
  })
}
