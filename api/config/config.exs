# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stone_challenge,
  ecto_repos: [StoneChallenge.Repo]

# Configures the endpoint
config :stone_challenge, StoneChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4QCJPce0hl8ZpH6kc6+TmzEAufkH3pk+hN2TUkZSEDwnihDqeMXc4COAOjXZfHkX",
  render_errors: [view: StoneChallengeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StoneChallenge.PubSub,
  live_view: [signing_salt: "HyhaGxUb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config(:stone_challenge, StoneChallenge.Guardian,
  issuer: "stone_challenge",
  secret_key: "eb5809c126d81bd437148fb82e752351"
)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
