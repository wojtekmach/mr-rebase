defmodule RebaseTest do
  use ExUnit.Case

  test "works" do
    token = System.get_env("TEST_TOKEN") || raise("TEST_TOKEN missing")
    org = System.get_env("TEST_ORG") || "wojtekmach"
    repo = System.get_env("TEST_REPO") || "mr-rebase-test"
    ref = System.get_env("TEST_REF") || "test2"

    Rebase.call(GitHub.client(token), org, repo, ref)
  end
end
