#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :size, :string
    field :sku, :string
    belongs_to :product, Sneakers23.Inventory.Product

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:sku, :size, :product_id])
    |> validate_required([:sku, :size, :product_id])
  end
end
