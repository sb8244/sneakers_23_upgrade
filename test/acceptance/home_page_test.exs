#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Acceptance.HomePageTest do
  use ExUnit.Case, async: false
  use Hound.Helpers

  setup do
    Hound.start_session()
    :ok
  end

  test "the page loads" do
    navigate_to("http://localhost:4002")
    assert page_title() == "Sneakers23"
  end
end
