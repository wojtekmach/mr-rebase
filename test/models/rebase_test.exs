defmodule RebaseTest do
  use ExUnit.Case
  require Logger

  test "works" do
    SystemUtils.with_tmpdir!(fn origin_dirname ->
      # Initial
      Git.init!(origin_dirname)

      SystemUtils.with_tmpdir!(fn _clone_dirname ->
        Git.clone!("file://#{origin_dirname}")
        Git.set_user!("Mr.Rebase+Test", "mr-rebase+test@wojtekmach.pl")

        SystemUtils.cmd!("touch a")
        Git.add!(".")
        Git.commit!("commit-a")
        [{_, "commit-a"}] = Git.log_oneline!

        # Create a new feature branch off master
        Git.branch!("some-feature")

        # Create commit on master
        SystemUtils.cmd!("touch b")
        Git.add!(".")
        Git.commit!("commit-b")
        [{_, "commit-b"}, {_, "commit-a"}] = Git.log_oneline!

        # Create commit on feature branch
        Git.checkout!("some-feature")
        SystemUtils.cmd!("touch c")
        Git.add!(".")
        Git.commit!("commit-c")
        [{_, "commit-c"}, {_, "commit-a"}] = Git.log_oneline!

        Git.push!("origin", "master")
        Git.push!("origin", "some-feature")

        Rebase.call!("file://#{origin_dirname}", "some-feature")

        Git.checkout!("some-feature")
        Git.pull_rebase!("origin", "some-feature")
        [{_, "commit-c"}, {_, "commit-b"}, {_, "commit-a"}] = Git.log_oneline!
      end)
    end)
  end
end
