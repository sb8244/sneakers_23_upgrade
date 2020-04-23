#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.ItemTest do
  use Sneakers23.DataCase, async: true
  alias Sneakers23.Inventory.Item

  test "an item can be inserted correctly" do
    params = Test.Factory.ItemFactory.params()

    assert {:ok, item = %Item{}} =
      %Item{}
      |> Item.changeset(params)
      |> Repo.insert()

    Enum.each(params, fn {key, val} ->
      assert Map.fetch!(item, key) == val
    end)
  end
end
