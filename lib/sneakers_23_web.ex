#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23Web do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Sneakers23Web, :controller
      use Sneakers23Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  defdelegate notify_product_released(product),
    to: Sneakers23Web.ProductChannel

  defdelegate notify_item_stock_change(opts),
    to: Sneakers23Web.ProductChannel

  def notify_local_item_stock_change(%{available_count: 0, id: id}) do
    Sneakers23.PubSub
    |> Phoenix.PubSub.node_name()
    |> Phoenix.PubSub.direct_broadcast(
      Sneakers23.PubSub, "item_out:#{id}", {:item_out, id}
    )
  end

  def notify_local_item_stock_change(_), do: false

  def controller do
    quote do
      use Phoenix.Controller, namespace: Sneakers23Web

      import Plug.Conn
      import Sneakers23Web.Gettext
      alias Sneakers23Web.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/sneakers_23_web/templates",
        namespace: Sneakers23Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Sneakers23Web.ErrorHelpers
      import Sneakers23Web.Gettext
      alias Sneakers23Web.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Sneakers23Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
