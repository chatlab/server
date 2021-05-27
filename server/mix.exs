defmodule SpotServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :spot_server,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SpotServer, []},
      extra_applications: [:logger, :cowboy, :plug]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.9"},
      {:credo, "~> 1.5"},
      {:plug, "~> 1.0"},
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 4.0"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
