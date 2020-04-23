#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.Store do
  import Ecto.Query

  alias Sneakers23.Repo
  alias Sneakers23.Inventory.{Item, ItemAvailability, Product}

  def all_products() do
    Repo.all(Product)
  end

  def all_items() do
    Repo.all(Item)
  end

  def all_item_availabilities() do
    Repo.all(ItemAvailability)
  end

  def mark_product_released!(product_id) do
    Product
    |> Repo.get!(product_id)
    |> Ecto.Changeset.change(released: true)
    |> Repo.update!()
  end

  def fetch_availability_for_item(item_id) do
    Repo.get_by(ItemAvailability, item_id: item_id)
  end

  def reduce_availability(item_id) do
    from(
      ia in ItemAvailability,
      where: ia.available_count > 0 and ia.item_id == ^item_id,
      update: [set: [available_count: fragment("available_count - 1")]]
    )
    |> Repo.update_all([])
    |> case do
      {1, nil} ->
        :ok

      _ ->
        {:error, :not_available}
    end
  end
end
