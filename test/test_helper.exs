ExUnit.start

Mix.Task.run "ecto.create", ~w(-r MrRebase.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r MrRebase.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(MrRebase.Repo)

