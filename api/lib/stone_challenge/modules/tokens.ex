defmodule StoneChallenge.Tokens do
  import Ecto.Query, warn: false
  require Logger

  alias StoneChallenge.Repo
  alias StoneChallenge.AuthToken
  alias StoneChallenge.Accounts.User

  alias StoneChallenge.Helper.BankingHelper

  def get_token(id) do
    Repo.get(AuthToken, id)
  end

  def get_token!(id) do
    Repo.get!(AuthToken, id)
  end

  def get_token_by(params) do
    Repo.get_by(AuthToken, params)
    |> Repo.preload(:user)
  end

  def list_tokens do
    Repo.all(AuthToken)
  end

  def remove_token(%AuthToken{} = auth_token) do
    Repo.delete(auth_token)
  end

  def register_token(%User{} = user, token) do
    Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
  end
end
