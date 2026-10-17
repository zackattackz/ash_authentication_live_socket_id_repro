defmodule Repro.Accounts.Token do
  use Ash.Resource,
    domain: Repro.Accounts,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshAuthentication.TokenResource],
    simple_notifiers: [AshAuthentication.Phoenix.TokenRevocationNotifier]

  token do
    endpoints [Repro.Endpoint]

    # The template `mix ash_authentication_phoenix.install` writes.
    live_socket_id_template &"users_sessions:#{&1["jti"]}"

    # The template the auto sign-out guide shows. With it, set_live_socket_id/2
    # raises FunctionClauseError instead:
    # live_socket_id_template fn %{jti: jti} -> "users_sessions:#{jti}" end
  end

  actions do
    defaults [:read]
  end
end
