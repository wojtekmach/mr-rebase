defmodule MrRebase.RepoControllerTest do
  use MrRebase.ConnCase

  test "GET /" do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Mr. Rebase"
  end
end
