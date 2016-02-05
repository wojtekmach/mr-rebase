defmodule Git do
  require Logger
  import SystemUtils, only: [cmd!: 1]

  def init!(dirname) do
    cmd!("git init --bare #{dirname}")
  end

  def clone!(url) do
    cmd!("git clone --quiet #{url} .")
  end

  def set_user!(name, email) do
    cmd!("git config user.name #{name}")
    cmd!("git config user.email #{email}")
  end

  def add!(pathspec) do
    cmd!("git add #{pathspec}")
  end

  def commit!(message) do
    cmd!("git commit -m #{message}")
  end

  def branch!(branch_name) do
    cmd!("git branch #{branch_name}")
  end

  def checkout!(branch_name) do
    cmd!("git checkout --quiet #{branch_name}")
  end

  def pull!(branch_name) do
    cmd!("git pull origin #{branch_name}")
  end

  def rebase!(branch_name) do
    cmd!("git rebase #{branch_name}")
  end

  def pull!(remote, branch_name) do
    cmd!("git pull #{remote} #{branch_name}")
  end

  def pull_rebase!(remote, branch_name) do
    cmd!("git pull --rebase --quiet #{remote} #{branch_name}")
  end

  def push!(remote, branch_name) do
    cmd!("git push --quiet #{remote} #{branch_name}")
  end

  def fetch!(remote, branch_name) do
    cmd!("git fetch --quiet #{remote} #{branch_name}")
  end

  def push_f!(remote, branch_name) do
    cmd!("git push -f --quiet #{remote} #{branch_name}")
  end

  def log_oneline!(branch_name \\ "") do
    lines = cmd!("git log --oneline #{branch_name}")

    lines
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(&extract_commit_info/1)
  end

  defp extract_commit_info(commit_line) do
    sha = String.slice(commit_line, 0..6)
    message = String.slice(commit_line, 8..1000)

    {sha, message}
  end
end
