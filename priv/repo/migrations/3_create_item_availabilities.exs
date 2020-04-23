#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
defmodule Sneakers23.Repo.Migrations.CreateItemAvailabilities do
  use Ecto.Migration

  def change do
    create table(:item_availabilities) do
      add :available_count, :integer, null: false
      add :item_id, references(:items, on_delete: :nothing), null: false

      timestamps(null: false)
    end

    create index(:item_availabilities, [:item_id])
  end
end
