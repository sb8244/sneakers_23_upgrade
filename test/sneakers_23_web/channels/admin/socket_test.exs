#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.Admin.SocketTest do
  use Sneakers23Web.ChannelCase

  import ExUnit.CaptureLog
  alias Sneakers23Web.Admin.Socket

  defp generate_token(id, opts \\ []) do
    salt = Keyword.get(opts, :salt, "admin socket")
    Phoenix.Token.sign(Sneakers23Web.Endpoint, salt, id)
  end

  describe "connect/3 success" do
    test "can be connected to with a valid token" do
      assert {:ok, %Phoenix.Socket{}} =
               connect(Socket, %{"token" => generate_token(1)})

      assert {:ok, %Phoenix.Socket{}} =
               connect(Socket, %{"token" => generate_token(2)})
    end
  end

  describe "connect/3 error" do
    test "cannot be connected to with an invalid salt" do
      params = %{"token" => generate_token(1, salt: "invalid")}

      assert capture_log(fn ->
               assert :error = connect(Socket, params)
             end) =~ "[error] #{Socket} connect error :invalid"
    end

    test "cannot be connected to without a token" do
      params = %{}

      assert capture_log(fn ->
               assert :error = connect(Socket, params)
             end) =~ "[error] #{Socket} connect error missing params"
    end

    test "cannot be connected to with a nonsense token" do
      params = %{"token" => "nonsense"}

      assert capture_log(fn ->
               assert :error = connect(Socket, params)
             end) =~ "[error] #{Socket} connect error :invalid"
    end
  end
end
