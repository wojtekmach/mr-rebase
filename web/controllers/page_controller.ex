defmodule MrRebase.PageController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    access_token = get_session(conn, :access_token)
    user = get_session(conn, :user)

    if access_token do
      client = Tentacat.Client.new(%{access_token: access_token})
      repositories = repositories_for_login(client, user.login)
    end

    render conn, "index.html", %{access_token: access_token, repositories: repositories, user: user}
  end

  def repo(conn, %{"user" => org, "repo" => repo}) do
    access_token = get_session(conn, :access_token)
    user = get_session(conn, :user)
    client = Tentacat.Client.new(%{access_token: access_token})
    prs = Tentacat.Pulls.filter org, repo, %{state: "open"}, client

    render conn, "repo.html", %{org: org, repo: repo, prs: prs}
  end

  def rebase(conn, %{"user" => org, "repo" => repo, "ref" => ref}) do
    access_token = get_session(conn, :access_token)
    Rebase.call(access_token, org, repo, ref)

    conn
    |> put_flash(:info, "PR was successfully rebased!")
    |> redirect(to: "/repos/#{org}/#{repo}")
  end

  def repositories_for_login(client, login) do
    Tentacat.get("users/#{login}/repos", client, %{per_page: 100})
  end
end
