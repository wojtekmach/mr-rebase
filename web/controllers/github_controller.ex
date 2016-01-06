defmodule MrRebase.GitHubController do
  use MrRebase.Web, :controller

  def callback(conn, params) do
    token = System.get_env("GITHUB_TOKEN") || raise("GITHUB_TOKEN missing")

    client = github_client(token)
    org = params["repository"]["owner"]["name"]
    repo = params["repository"]["name"]

    pull_requests(client, org, repo)
    |> Enum.each(fn pr ->
      Rebase.call(token, org, repo, pr["head"]["ref"])
    end)

    conn
    |> json(%{status: :ok})
  end

  defp github_client(access_token) do
    Tentacat.Client.new(%{access_token: access_token})
  end

  defp pull_requests(client, org, repo) do
    Tentacat.Pulls.filter(org, repo, %{state: "open"}, client)
  end
end
