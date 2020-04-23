#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Inventory.ServerTest do
  use ExUnit.Case, async: true
  alias Sneakers23.Inventory.{Inventory, Server}

  defmodule FakeLoader do
    def load() do
      {:ok, Inventory.new()}
    end
  end

  describe "start_link/1" do
    test "the process starts and loads from the loader", %{test: test_name} do
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: FakeLoader)
      assert :sys.get_state(pid) == Inventory.new()
    end
  end

  describe "get_inventory/1" do
    test "the inventory is returned", %{test: test_name} do
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: FakeLoader)
      assert Server.get_inventory(pid) == {:ok, Inventory.new()}
    end
  end
end
