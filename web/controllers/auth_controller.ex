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
    user = get_user(token)

    conn
    |> put_session(:access_token, token.access_token)
    |> put_session(:user, user)
    |> redirect(to: "/")
  end

  defp get_user(token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "/user")
    %{name: user["name"], login: user["login"], avatar_url: user["avatar_url"]}
  end
end
