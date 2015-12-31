defmodule MrRebase.PageController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    access_token = get_session(conn, :access_token)
    render conn, "index.html", %{access_token: access_token}
  end
end
