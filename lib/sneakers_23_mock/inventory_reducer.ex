#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Mock.InventoryReducer do
  @moduledoc """
  Provides a mocked experience of the inventory decreasing for the store. The
  quickest way to use this is to invoke `sell_random_until_gone!/0`:

  ```
    Sneakers23Mock.InventoryReducer.sell_random_until_gone!()
  ```

  You can adjust the amount_per_tick and tick_duration as well.
  """

  require Logger

  alias Sneakers23.Inventory

  def sell_random_until_gone!(amount_per_tick \\ 200, tick_duration \\ 250) do
    spawn_link(fn -> sell_until_gone!(amount_per_tick, tick_duration) end)
  end

  def sell_random!(count \\ 100)
  def sell_random!(0), do: :ok

  def sell_random!(count) do
    {:ok, products} = Inventory.get_complete_products()

    case sell_from_products(products) do
      :ok ->
        sell_random!(count - 1)

      {:error, :empty} ->
        :empty
    end
  end

  defp sell_until_gone!(amount, tick_duration) do
    case sell_random!(amount) do
      :ok ->
        Logger.info("#{__MODULE__} still selling...")
        Process.sleep(tick_duration)
        sell_until_gone!(amount, tick_duration)

      :empty ->
        Logger.info("#{__MODULE__} sold out!")
        :done
    end
  end

  defp sell_from_products(products) do
    with items <- get_available_items(products),
         {:ok, %{id: id}} <- select_random_item(items),
         :ok <- Sneakers23.Checkout.SingleItem.sell_item(id) do
      :ok
    else
      {:error, :not_available} ->
        :ok

      e ->
        e
    end
  end

  defp get_available_items(products) do
    products
    |> Enum.map(& &1.items)
    |> List.flatten()
    |> Enum.filter(&(&1.available_count > 0))
  end

  defp select_random_item([]), do: {:error, :empty}

  defp select_random_item(items), do: {:ok, Enum.random(items)}
end
