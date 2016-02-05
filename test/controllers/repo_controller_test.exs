defmodule MrRebase.RepoControllerTest do
  use MrRebase.ConnCase

  test "index: when not authenticated" do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Connect to GitHub"
  end

  test "index: when authenticated" do
    conn = conn
    |> bypass_through(MrRebase.Router, [:browser])
    |> get("/")
    |> put_session(:access_token, "abcd")
    |> put_session(:user, %{login: "test"})
    |> send_resp(:ok, "")
    |> recycle
    |> get("/")

    assert conn.status == 200
    assert conn.resp_body =~ ~r"User:.*https://github.com/test"
    assert conn.resp_body =~ ~r"Token:.*abcd"
    assert conn.resp_body =~ ~r"repo1"
    assert conn.resp_body =~ ~r"repo2"
  end

  test "show" do
    conn = get conn, "/repos/user1/repo1"
    assert conn.status == 200
    assert conn.resp_body =~ "https://github.com/user1/repo1"
    assert conn.resp_body =~ "PR 1"
    assert conn.resp_body =~ "PR 2"
  end
end
