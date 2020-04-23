#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.Admin.DashboardChannelTest do
  use Sneakers23Web.ChannelCase

  alias Sneakers23Web.Admin.{Socket}
  alias Sneakers23Web.CartTracker

  defp connect() do
    assert {:ok, _, socket} =
      socket(Socket, nil, %{})
      |> subscribe_and_join("admin:cart_tracker", %{})

    socket
  end

  test "the Channel is pushed an empty state upon join" do
    connect()

    assert_push "presence_state", %{}
  end

  test "the Channel is pushed the CartTracker state upon join" do
    CartTracker.track_cart(%{
      channel_pid: self()
    }, %{
      cart: %{items: [1, 2]},
      id: "test",
      page: "page"
    })

    connect()

    assert_push "presence_state", %{
      "test" => %{
        metas: [%{
          items: [1, 2],
          page: "page",
          page_loaded_at: _,
          phx_ref: _
        }]
      }
    }
  end
end
