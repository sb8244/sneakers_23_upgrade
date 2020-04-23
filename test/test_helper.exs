#---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
#---
Application.ensure_all_started(:hound)
ExUnit.start()

# Only change the Sandbox mode to manual once the Inventory process is done loading
# Otherwise, an error will occur due to how mode changes work.
:sys.get_state(Sneakers23.Inventory)
Ecto.Adapters.SQL.Sandbox.mode(Sneakers23.Repo, :manual)
