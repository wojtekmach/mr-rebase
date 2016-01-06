defmodule MrRebase.PageController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    access_token = get_session(conn, :access_token)
    user = get_session(conn, :user)

    if access_token do
      repositories = github_client(conn) |> GitHub.repositories(user.login)
    end

    render conn, "index.html", %{access_token: access_token, repositories: repositories, user: user}
  end

  def repo(conn, %{"user" => org, "repo" => repo}) do
    prs = github_client(conn) |> GitHub.pull_requests(org, repo)

    render conn, "repo.html", %{org: org, repo: repo, prs: prs}
  end

  def rebase(conn, %{"user" => org, "repo" => repo, "ref" => ref}) do
    github_client(conn) |> Rebase.call(org, repo, ref)

    conn
    |> put_flash(:info, "PR was successfully rebased!")
    |> redirect(to: "/repos/#{org}/#{repo}")
  end

  defp github_client(conn) do
    get_session(conn, :access_token) |> GitHub.client
  end
end
