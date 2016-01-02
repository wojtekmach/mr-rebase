defmodule MrRebase.AuthController do
  use MrRebase.Web, :controller

  def index(conn, _params) do
    redirect conn, external: GitHub.authorize_url!(scope: "public_repo")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"code" => code}) do
    token = GitHub.get_token!(code: code)

    conn
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end
end
