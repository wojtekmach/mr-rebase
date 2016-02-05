defmodule GitHubFake do
  def repositories(_client, _username) do
    [
      %GitHub.Repository{name: "repo1"},
      %GitHub.Repository{name: "repo2"},
    ]
  end

  def pull_requests(_client, org, repo) do
    [
      %GitHub.PullRequest{title: "PR 1", url: "https://github.com/#{org}/#{repo}/pull/1", branch: "pr-1"},
      %GitHub.PullRequest{title: "PR 2", url: "https://github.com/#{org}/#{repo}/pull/2", branch: "pr-2"},
    ]
  end
end
