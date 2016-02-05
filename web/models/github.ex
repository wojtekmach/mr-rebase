defmodule GitHub do
  defmodule Repository do
    defstruct name: ""
  end

  defmodule PullRequest do
    defstruct title: "", url: "", branch: ""
  end

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
