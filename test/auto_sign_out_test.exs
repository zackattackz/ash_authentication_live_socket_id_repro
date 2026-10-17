defmodule Repro.AutoSignOutTest do
  use ExUnit.Case

  import Plug.Conn
  import Plug.Test

  test "revoking a session's token disconnects its LiveViews" do
    user = Ash.Seed.seed!(Repro.Accounts.User, %{})
    {:ok, token, _claims} = AshAuthentication.Jwt.token_for_user(user)

    # Sign-in: store the session's live socket id, as the auth controller does.
    conn =
      conn(:get, "/")
      |> init_test_session(%{})
      |> put_private(:phoenix_endpoint, Repro.Endpoint)
      |> AshAuthentication.Phoenix.Controller.set_live_socket_id(token)

    topic = get_session(conn, :live_socket_id)

    # Listen where the session's LiveViews listen, and on the empty topic.
    Repro.Endpoint.subscribe(topic)
    Repro.Endpoint.subscribe("users_sessions:")

    # Sign-out: revoking the token runs TokenRevocationNotifier.
    :ok = AshAuthentication.TokenResource.revoke(Repro.Accounts.Token, token)

    receive do
      %Phoenix.Socket.Broadcast{topic: sent_to, event: "disconnect"} ->
        assert sent_to == topic
    after
      500 -> flunk("no disconnect broadcast")
    end
  end
end
