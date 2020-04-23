#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.CartIdPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Sneakers23Web.CartIdPlug

  test "a new cart id is assigned if one isn't present" do
    assert conn(:get, "/")
      |> init_test_session(%{})
      |> CartIdPlug.call([])
      |> get_session()
      |> Map.fetch!("cart_id")
      |> byte_size() == 64
  end

  test "the same cart id is assigned if one was present" do
    assert conn(:get, "/")
      |> init_test_session(%{"cart_id" => "test"})
      |> CartIdPlug.call([])
      |> get_session()
      |> Map.fetch!("cart_id") == "test"
  end
end
