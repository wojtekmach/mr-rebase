defmodule MrRebase.PageControllerTest do
  use MrRebase.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Mr. Rebase"
  end

  # test "POST /repos/:org/:repo/:pr_id", %{conn: conn} do
  # end
end
