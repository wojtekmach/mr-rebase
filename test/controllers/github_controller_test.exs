defmodule MrRebase.GitHubControllerTest do
  use MrRebase.ConnCase

  @tag :external
  test "POST /github/callback" do
    payload = """
{
  "ref": "refs/heads/master",
  "before": "b6c66502a6647c2f4b131a6cec9888c552e319e5",
  "after": "01b6de9801e438be735f903a06998532c19fffd2",
  "created": false,
  "deleted": false,
  "forced": false,
  "base_ref": null,
  "compare": "https://github.com/wojtekmach/mr-rebase-test/compare/b6c66502a664...01b6de9801e4",
  "commits": [
  ],
  "head_commit": {
  },
  "repository": {
    "id": 48844218,
    "name": "mr-rebase-test",
    "full_name": "wojtekmach/mr-rebase-test",
    "owner": {
      "name": "wojtekmach",
      "email": "wojtekmach@users.noreply.github.com"
    },
    "url": "https://github.com/wojtekmach/mr-rebase-test"
  },
  "pusher": {
    "name": "wojtekmach",
    "email": "wojtekmach@users.noreply.github.com"
  },
  "sender": {
    "login": "wojtekmach",
    "id": 76071
  }
}
""" |> Poison.decode!

    conn = conn()
    |> put_req_header("accept", "application/json")
    |> post("/github/callback", payload)

    assert json_response(conn, 200) == %{"status" => "ok"}
  end
end
