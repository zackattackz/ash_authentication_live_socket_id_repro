# AshAuthentication auto sign-out: `live_socket_id_template` key mismatch

Minimal reproduction for an AshAuthentication.Phoenix bug: signing out does
not disconnect the session's LiveViews, because `live_socket_id_template` is
called with string keys at sign-in and atom keys at revocation.

- ash 3.36.1, ash_authentication 5.0.0-rc.14, ash_authentication_phoenix 3.0.0-rc.11
- Elixir 1.20.4, Erlang/OTP 29 (`.tool-versions`)
- No database: both resources use `Ash.DataLayer.Ets`. The only other piece
  is a bare `Phoenix.Endpoint` to broadcast through.

## Run

```sh
mix deps.get
mix test
```

The test (`test/auto_sign_out_test.exs`) stores a session's live socket id with
`AshAuthentication.Phoenix.Controller.set_live_socket_id/2`, subscribes to it,
revokes the token with `AshAuthentication.TokenResource.revoke/2` (which runs
`TokenRevocationNotifier`), and expects the `"disconnect"` broadcast on that
topic. It fails:

```
Assertion with == failed
code:  assert sent_to == topic
left:  "users_sessions:"
right: "users_sessions:33fmh2o6f44gkru1300005c1"
```

The token resource (`lib/repro/accounts/token.ex`) uses the template
`mix ash_authentication_phoenix.install` writes. Switching to the template the
auto sign-out guide shows (commented out in that file) makes
`set_live_socket_id/2` raise `FunctionClauseError` instead.

The `"does not support row locking"` warning comes from the ETS data layer and
is unrelated.
