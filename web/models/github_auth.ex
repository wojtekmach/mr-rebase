# https://github.com/scrogson/oauth2_example/blob/214f84aa690dbdc640613a8673c90c79d8f5767a/web/oauth/github.ex

defmodule GitHubAuth do
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: GitHubAuth,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
  end

  # Public API

  def client do
    Application.get_env(:mr_rebase, GitHubAuth)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
