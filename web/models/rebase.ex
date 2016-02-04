defmodule Rebase do
  require Logger

  def call!(url, branch) do
    SystemUtils.with_tmpdir!(fn _dirname ->
      Git.clone!(url)
      SystemUtils.cmd!("git config user.email mr-rebase@wojtekmach.pl")
      SystemUtils.cmd!("git config user.name Mr.Rebase")

      Git.fetch!("origin", branch)
      Git.checkout!(branch)
      Git.rebase!("origin/master")
      Git.push_f!("origin", branch)
    end)
  end
end
