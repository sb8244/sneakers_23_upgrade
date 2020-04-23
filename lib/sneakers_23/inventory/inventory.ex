#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.Inventory do
  defstruct items: %{}, products: %{}, availability: %{}

  def new() do
    %__MODULE__{}
  end

  def add_products(state = %{products: products}, to_add) do
    new_products = Enum.reduce(to_add, products, fn product, products ->
      Map.put(products, product.id, product)
    end)

    %{state | products: new_products}
  end

  def add_items(state = %{items: items}, to_add) do
    new_items = Enum.reduce(to_add, items, fn item, items ->
      Map.put(items, item.id, item)
    end)

    %{state | items: new_items}
  end

  def add_availabilities(state = %{availability: availability}, to_add) do
    new_avail = Enum.reduce(to_add, availability, fn ia, availability ->
      Map.put(availability, ia.id, ia)
    end)

    %{state | availability: new_avail}
  end

  def get_items_for_product(%{items: items}, %{id: product_id}) do
    items
    |> Map.values()
    |> Enum.filter(&(&1.product_id == product_id))
  end

  def get_availability_for_item(%{availability: avail}, %{id: item_id}) do
    avail
    |> Map.values()
    |> Enum.find(& &1.item_id == item_id)
  end

  def mark_product_released!(state = %{products: products}, id) do
    product = Map.fetch!(products, id)
    new_product = Map.put(product, :released, true)
    new_products = Map.put(products, id, new_product)
    %{state | products: new_products}
  end
end
