#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :brand, :string
    field :color, :string
    field :main_image_url, :string
    field :name, :string
    field :order, :integer
    field :price_usd, :integer
    field :released, :boolean, default: false
    field :sku, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :order, :brand, :name, :color, :price_usd, :main_image_url, :released])
    |> validate_required([:sku, :order, :brand, :name, :color, :price_usd, :main_image_url, :released])
  end
end
