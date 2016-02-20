defmodule MrRebase.GitHubController do
  use MrRebase.Web, :controller

  @github_api Application.get_env(:mr_rebase, :github_api)

  def callback(conn, params) do
    token = System.get_env("GITHUB_TOKEN")

    client = @github_api.client(token)
    org = params["repository"]["owner"]["name"]
    repo = params["repository"]["name"]

    url = "https://#{token}@github.com/#{org}/#{repo}"

    @github_api.pull_requests(client, org, repo)
    |> Enum.each(fn pr ->
      Rebase.call!(url, pr.branch)
    end)

    conn
    |> json(%{status: :ok})
  end
end
