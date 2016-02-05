defmodule MrRebase.GitHubController do
  use MrRebase.Web, :controller

  def callback(conn, params) do
    token = System.get_env("GITHUB_TOKEN") || raise("GITHUB_TOKEN missing")

    client = GitHub.client(token)
    org = params["repository"]["owner"]["name"]
    repo = params["repository"]["name"]

    url = "https://#{client.auth.access_token}@github.com/#{org}/#{repo}"

    GitHub.pull_requests(client, org, repo)
    |> Enum.each(fn pr ->
      Rebase.call!(url, pr.branch)
    end)

    conn
    |> json(%{status: :ok})
  end
end
