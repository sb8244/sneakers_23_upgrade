/***
 * Excerpted from "Real-Time Phoenix",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
***/
export function getCartHtml({ items, serialized }) {
  if (items.length === 0) {
    return ""
  } else {
    return `
      <form class="cart-container" action="/checkout" method="GET">
        <input type="hidden" name="serialized_cart" value="${serialized}" />

        <div class="cart-header">
          Cart ${items.length}
        </div>

        <div class="cart-items">
          ${items.map(renderCartItem).join("")}
        </div>

        <div class="cart-subtotal">
          Subtotal $${sumItemPrices(items)}
        </div>

        <div>
          <input class="cart-checkout" type="submit" value="CHECKOUT" />
        </div>
      </form>
    `
  }
}

function sumItemPrices(items) {
  return items.reduce((acc, item) => acc + item.price_usd, 0)
}

function renderCartItem(item) {
  const outOfStockStyle = item.out_of_stock ? "cart-item-out" : ""

  return `
    <div class="cart-item">
      <div class="cart-item__remove" data-item-id="${item.id}">&times;</div>
      <div class="cart-item__contents ${outOfStockStyle}">
        <div>
          <span>${item.brand}</span> <b>${item.name}</b>
        </div>
        <div>
          <span>${item.size}</span>
        </div>
      </div>
      <div class="cart-item__price ${outOfStockStyle}">
        $${item.price_usd}
      </div>
    </div>
  `
}
