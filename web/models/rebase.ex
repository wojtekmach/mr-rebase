defmodule Rebase do
  def call!(url, branch) do
    SystemUtils.with_tmpdir!(fn _dirname ->
      Git.clone!(url)
      Git.set_user!("Mr.Rebase", "mr-rebase@wojtekmach.pl")
      Git.fetch!("origin", branch)
      Git.checkout!(branch)
      Git.rebase!("origin/master")
      Git.push_f!("origin", branch)
    end)
  end
end
