defmodule GitHub do
  def client(access_token) do
    Tentacat.Client.new(%{access_token: access_token})
  end

  def pull_requests(client, org, repo) do
    Tentacat.Pulls.filter(org, repo, %{state: "open"}, client)
  end

  def repositories(client, username) do
    Tentacat.get("users/#{username}/repos", client, %{per_page: 100})
  end
end
