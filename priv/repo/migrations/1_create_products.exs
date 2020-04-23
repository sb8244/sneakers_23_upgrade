#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :sku, :string, null: false
      add :order, :integer, null: false
      add :brand, :string, null: false
      add :name, :string, null: false
      add :color, :string, null: false
      add :price_usd, :integer, null: false
      add :main_image_url, :string, null: false
      add :released, :boolean, default: false, null: false

      timestamps(null: false)
    end

    create unique_index(:products, [:sku])
  end
end
