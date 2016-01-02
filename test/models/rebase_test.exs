defmodule RebaseTest do
  use ExUnit.Case

  test "works" do
    token = System.get_env("TEST_TOKEN") || raise("TEST_TOKEN missing")
    org = System.get_env("TEST_ORG") || raise("TEST_ORG missing")
    repo = System.get_env("TEST_REPO") || raise("TEST_REPO missing")
    ref = System.get_env("TEST_REF") || raise("TEST_REF missing")

    Rebase.call(token, org, repo, ref)
  end
end
