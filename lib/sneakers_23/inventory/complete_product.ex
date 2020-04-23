#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.CompleteProduct do
  alias Sneakers23.Inventory.Inventory

  def get_complete_products(inventory = %Inventory{products: products}) do
    products
    |> Map.values()
    |> Enum.sort_by(& &1.order)
    |> Enum.map(fn %{id: id} ->
      {:ok, product} = get_product_by_id(inventory, id)
      product
    end)
  end

  def get_product_by_id(inventory, product_id) do
    with {:ok, product} <- Map.fetch(inventory.products, product_id),
         product_items <-
           Inventory.get_items_for_product(inventory, product),
         items <- enrich_product_items(product_items, inventory),
         itemized_product <- Map.put(product, :items, items) do
      {:ok, itemized_product}
    end
  end

  defp enrich_product_items(items, inventory) do
    items
    |> Enum.map(&put_availability_onto_item(&1, inventory))
  end

  defp put_availability_onto_item(item, inventory) do
    available_count =
      Inventory.get_availability_for_item(inventory, item)
      |> Map.get(:available_count, 0)

    Map.put(item, :available_count, available_count)
  end

  def get_item_by_id(inventory = %{items: items}, id) do
    case Map.fetch(items, id) do
      :error -> {:error, :not_found}
      {:ok, item} ->
        item = put_availability_onto_item(item, inventory)
        {:ok, item}
    end
  end
end
