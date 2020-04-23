#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Test.Factory.ItemFactory do
  alias Sneakers23.Repo
  alias Sneakers23.Inventory.Item
  alias Test.Factory.ProductFactory

  def params(overrides \\ %{}) do
    product_id = Map.get_lazy(overrides, :product_id, fn ->
      ProductFactory.create!().id
    end)

    %{
      sku: "SHU_1",
      size: "10",
      product_id: product_id
    } |> Map.merge(overrides)
  end

  def create!(overrides \\ %{}) do
    %Item{}
    |> Item.changeset(params(overrides))
    |> Repo.insert!()
  end
end
