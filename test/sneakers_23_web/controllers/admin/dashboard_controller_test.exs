#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.DashboardControllerTest do
  use Sneakers23Web.ConnCase, async: true

  test "an admin token is included in the view", %{conn: conn} do
    html =
      conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:password"))
      |> get("/admin")
      |> html_response(200)

    assert html =~ "window.adminToken ="
  end
end
