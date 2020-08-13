use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stone_challenge, StoneChallenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "stone_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "104.248.48.177",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stone_challenge, StoneChallengeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
