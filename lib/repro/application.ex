defmodule Repro.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Repro.PubSub},
      Repro.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Repro.Supervisor)
  end
end
