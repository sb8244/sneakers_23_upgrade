#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.ProductView do
  use Sneakers23Web, :view

  def product_size_options(product) do
    product.items
    |> Enum.map(fn item ->
      %{
        text: item.size,
        id: item.id,
        level: availability_to_level(item.available_count),
        disabled?: item.available_count == 0
      }
    end)
  end

  def availability_to_level(count) when count == 0, do: "out"
  def availability_to_level(count) when count < 150, do: "low"
  def availability_to_level(count) when count < 500, do: "medium"
  def availability_to_level(_), do: "high"
end
