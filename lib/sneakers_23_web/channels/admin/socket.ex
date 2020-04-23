#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web.Admin.Socket do
  use Phoenix.Socket
  require Logger

  ## Channels
  channel "admin:cart_tracker", Sneakers23Web.Admin.DashboardChannel

  def connect(%{"token" => token}, socket) do
    case verify(socket, token) do
      {:ok, _} ->
        {:ok, socket}

      {:error, err} ->
        Logger.error("#{__MODULE__} connect error #{inspect(err)}")
        :error
    end
  end

  def connect(_, _) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  def id(_socket), do: nil

  @one_day 86400

  defp verify(socket, token),
    do:
      Phoenix.Token.verify(
        socket,
        "admin socket",
        token,
        max_age: @one_day
      )
end
