import Config

config :repro, ash_domains: [Repro.Accounts]

config :repro, Repro.Endpoint,
  pubsub_server: Repro.PubSub,
  secret_key_base: String.duplicate("a", 64),
  server: false

config :phoenix, :json_library, Jason

config :logger, level: :warning

# Required by Ash 3.36.
config :ash, default_string_length_count: :codepoints
