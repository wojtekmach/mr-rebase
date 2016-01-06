defmodule Rebase do
  def call(token, org, repo, branch) do
    url = "https://#{token}@github.com/#{org}/#{repo}"

    with_tmpdir!(fn _dirname ->
      IO.puts "Cloning..."
      IO.inspect System.cmd("git", ["clone", url, "."])

      :timer.sleep(1000)
      IO.inspect "On master branch"
      IO.inspect System.cmd("git", ["log", "--oneline", "-1"])

      :timer.sleep(1000)
      IO.puts "Switching branch..."
      IO.inspect System.cmd("git", ["fetch", "origin", branch])
      IO.inspect System.cmd("git", ["checkout", branch])
      IO.inspect "On #{branch} branch"
      IO.inspect System.cmd("git", ["log", "--oneline", "-1"])

      :timer.sleep(1000)
      IO.puts "Rebasing..."
      IO.inspect System.cmd("git", ["rebase", "master"])

      :timer.sleep(1000)
      IO.inspect System.cmd("git", ["log", "--oneline"])

      :timer.sleep(1000)
      IO.puts "Pushing..."
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
