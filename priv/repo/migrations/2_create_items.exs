#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :sku, :string, null: false
      add :size, :string, null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps(null: false)
    end

    create index(:items, [:product_id])
    create unique_index(:items, [:sku])
  end
end
