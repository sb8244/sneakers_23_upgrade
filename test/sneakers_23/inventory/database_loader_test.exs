#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.DatabaseLoaderTest do
  use Sneakers23.DataCase, async: true

  alias Sneakers23.Inventory.{DatabaseLoader, Inventory}

  describe "load/0" do
    test "an empty inventory can be loaded" do
      assert DatabaseLoader.load() == {:ok, Inventory.new()}
    end

    test "all records are loaded" do
      {expected, _} = Test.Factory.InventoryFactory.complete_products()
      assert DatabaseLoader.load() == {:ok, expected}
    end
  end
end
