defmodule Repro.Accounts.User do
  use Ash.Resource,
    domain: Repro.Accounts,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshAuthentication]

  authentication do
    tokens do
      enabled? true
      token_resource Repro.Accounts.Token
      store_all_tokens? true
      signing_secret fn _, _ -> {:ok, String.duplicate("s", 64)} end
    end
  end

  actions do
    defaults [:read]
  end

  attributes do
    uuid_primary_key :id
  end
end
