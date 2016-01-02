defmodule MrRebase.PageController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    access_token = get_session(conn, :access_token)
    user = get_session(conn, :user)

    if access_token do
      repositories = Tentacat.Repositories.list_users(user.login)
    end

    render conn, "index.html", %{access_token: access_token, repositories: repositories, user: user}
  end
end
