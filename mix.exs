defmodule Repro.MixProject do
  use Mix.Project

  def project do
    [
      app: :repro,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {Repro.Application, []}]
  end

  defp deps do
    [
      {:ash, "== 3.36.1"},
      {:ash_authentication, "== 5.0.0-rc.14"},
      {:ash_authentication_phoenix, "== 3.0.0-rc.11"},
      {:jason, "~> 1.4"}
    ]
  end
end
