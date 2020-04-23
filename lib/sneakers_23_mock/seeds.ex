#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Mock.Seeds do
  @moduledoc """
  Provides Ecto data inserts for a fake set of data. Run this clean by
  executing `mix ecto.reset` before running `Sneakers23Mock.Seeds.seed!()`.

  Products have to be released via a function call on the Inventory context:

  ```
    Sneakers23.Inventory.mark_product_released!("SHU6000")
    Sneakers23.Inventory.mark_product_released!("SHU6100")
  ```
  """

  alias Sneakers23.Repo
  alias Sneakers23.Inventory.{Item, ItemAvailability, Product}

  def seed!() do
    Sneakers23.Repo.transaction(fn ->
      products =
        mock_products()
        |> Enum.map(fn product ->
          create_product!(product)
        end)

      items =
        mock_items()
        |> Enum.map(fn item ->
          create_item!(item, products)
        end)

      mock_availability(items)
      |> Enum.map(&create_item_availability!/1)
    end)
  end

  def create_product!(params) do
    %Product{}
    |> Product.changeset(params)
    |> Repo.insert!()
  end

  def create_item!(params = %{product_sku: psku}, products) do
    product = Enum.find(products, & &1.sku == psku)
    params = Map.put(params, :product_id, product.id)

    %Item{}
    |> Item.changeset(params)
    |> Repo.insert!()
  end

  def create_item_availability!(params) do
    %ItemAvailability{}
    |> ItemAvailability.changeset(params)
    |> Repo.insert!()
  end

  defp mock_items() do
    mock_products()
    |> Enum.map(fn listing ->
      Enum.map(listing.sizes, fn {sku, size} ->
        %{
          product_sku: listing.sku,
          sku: sku,
          size: size
        }
      end)
    end)
    |> List.flatten()
  end

  defp mock_products(),
    do: [
      %{
        sku: "SHU6000",
        order: 0,
        brand: "Snks 23",
        name: "Hop Man 3",
        color: "yellow/blue",
        main_image_url: "/images/hopman.png",
        price_usd: 120,
        sizes: %{
          "SHU6001" => "6",
          "SHU6002" => "6.5",
          "SHU6003" => "7",
          "SHU6004" => "7.5",
          "SHU6005" => "8",
          "SHU6006" => "8.5",
          "SHU6007" => "9",
          "SHU6008" => "9.5",
          "SHU6009" => "10",
          "SHU6010" => "10.5",
          "SHU6011" => "11",
          "SHU6012" => "11.5",
          "SHU6013" => "12"
        }
      },
      %{
        sku: "SHU6100",
        order: 1,
        brand: "Asler",
        name: "Breezy Boost 600",
        color: "momentum",
        main_image_url: "/images/breezy.png",
        price_usd: 140,
        sizes: %{
          "SHU6101" => "6",
          "SHU6102" => "6.5",
          "SHU6103" => "7",
          "SHU6104" => "7.5",
          "SHU6105" => "8",
          "SHU6106" => "8.5",
          "SHU6107" => "9",
          "SHU6108" => "9.5",
          "SHU6109" => "10",
          "SHU6110" => "10.5",
          "SHU6111" => "11",
          "SHU6112" => "11.5",
          "SHU6113" => "12"
        }
      }
    ]

  defp mock_availability(items),
    do:
      Enum.map(items, fn %{id: item_id} ->
        available = if :rand.uniform() < 0.1, do: 0, else: :rand.uniform(1000) + 200
        %{item_id: item_id, available_count: available}
      end)
end
