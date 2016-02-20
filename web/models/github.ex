defmodule GitHub do
  defmodule Repository do
    defstruct name: ""
  end

  defmodule PullRequest do
    defstruct title: "", url: "", branch: ""
  end

  @callback pull_requests(any, String.t, String.t) :: [PullRequest.t]

  @callback repositories(any, String.t) :: [Repository.t]
end

defmodule GitHub.Real do
  @behaviour GitHub

  alias GitHub.{PullRequest, Repository}

  def client(access_token) do
    Tentacat.Client.new(%{access_token: access_token})
  end

  def pull_requests(client, org, repo) do
    Tentacat.Pulls.filter(org, repo, %{state: "open"}, client)
    |> Enum.map(fn pr -> %PullRequest{title: pr["title"], url: pr["html_url"], branch: pr["head"]["ref"]} end)
  end

  def repositories(client, username) do
    Tentacat.get("users/#{username}/repos", client, %{per_page: 100})
    |> Enum.map(fn repo -> %Repository{name: repo["name"]} end)
  end
end

defmodule GitHub.Fake do
  @behaviour GitHub

  alias GitHub.{PullRequest, Repository}

  def client(_access_token), do: :client

  def repositories(_client, _username) do
    [
      %Repository{name: "repo1"},
      %Repository{name: "repo2"},
    ]
  end

  def pull_requests(_client, org, repo) do
    [
      %PullRequest{title: "PR 1", url: "https://github.com/#{org}/#{repo}/pull/1", branch: "pr-1"},
      %PullRequest{title: "PR 2", url: "https://github.com/#{org}/#{repo}/pull/2", branch: "pr-2"},
    ]
  end
end
