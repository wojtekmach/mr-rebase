defmodule Rebase do
  def call(token, org, repo, branch) do
    url = "https://#{token}@github.com/#{org}/#{repo}"
    dirname = "tmp/repos/#{org}-#{repo}-#{SecureRandom.uuid}"
    File.mkdir_p!(dirname)
    File.cd!(dirname)
    System.cmd("git", ["clone", url, "."])
    IO.inspect System.cmd("git", ["fetch", "origin", branch])
    IO.inspect System.cmd("git", ["checkout", branch])
    IO.inspect System.cmd("git", ["rebase", "master"])
    IO.inspect System.cmd("git", ["push", "-f", "origin", branch])

    File.cd!("../../..")
    File.rm_rf!(dirname)
  end
end
