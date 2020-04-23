#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.ItemAvailability do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_availabilities" do
    field :available_count, :integer
    belongs_to :item, Sneakers23.Inventory.Item

    timestamps()
  end

  @doc false
  def changeset(item_availability, attrs) do
    item_availability
    |> cast(attrs, [:available_count, :item_id])
    |> validate_required([:available_count, :item_id])
  end
end
