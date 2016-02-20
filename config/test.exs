use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mr_rebase, MrRebase.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :mr_rebase, MrRebase.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "mr_rebase_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :mr_rebase, :github_api, GitHub.Fake
