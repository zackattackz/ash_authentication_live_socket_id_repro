defmodule Repro.Accounts do
  use Ash.Domain, otp_app: :repro

  resources do
    resource Repro.Accounts.User
    resource Repro.Accounts.Token
  end
end
