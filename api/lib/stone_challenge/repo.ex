defmodule StoneChallenge.Repo do
  use Ecto.Repo,
    otp_app: :stone_challenge,
    adapter: Ecto.Adapters.Postgres
end
