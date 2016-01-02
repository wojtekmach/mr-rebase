defmodule Rebase do
  def call(token, org, repo, branch) do
    url = "https://#{token}@github.com/#{org}/#{repo}"

    with_tmpdir!(fn _dirname ->
      IO.inspect System.cmd("git", ["clone", url, "."])
      IO.inspect System.cmd("git", ["fetch", "origin", branch])
      IO.inspect System.cmd("git", ["checkout", branch])
      IO.inspect System.cmd("git", ["rebase", "master"])
      IO.inspect System.cmd("git", ["push", "-f", "origin", branch])
    end)
  end

  def with_tmpdir!(f, prefix \\ "") do
    cwd = System.cwd!
    dirname = System.tmp_dir! <> "/" <> prefix <> SecureRandom.uuid
    File.mkdir_p!(dirname)
    File.cd!(dirname)
    f.(dirname)
    File.cd!(cwd)
    File.rm_rf!(dirname)
  end
end
