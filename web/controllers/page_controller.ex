defmodule MrRebase.PageController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
