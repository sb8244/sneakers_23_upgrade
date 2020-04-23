#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Test.Factory.ProductFactory do
  alias Sneakers23.Repo
  alias Sneakers23.Inventory.Product

  def params(overrides \\ %{}) do
    %{
      sku: "PRO_1",
      brand: "brand",
      color: "color",
      main_image_url: "url",
      name: "name",
      order: 1,
      price_usd: 100,
      released: false
    } |> Map.merge(overrides)
  end

  def create!(overrides \\ %{}) do
    %Product{}
    |> Product.changeset(params(overrides))
    |> Repo.insert!()
  end
end
