defmodule Aletopelta.MixProject do
  use Mix.Project

  def project do
    [
      app: :aletopelta,
      version: "0.7.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      consolidate_protocols: Mix.env() != :test
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Aletopelta, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:belodon, "~> 0.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  # Define project-specific aliases here.
  defp aliases do
    [
      runx: "run lib/aletopelta.ex"
    ]
  end

  # 'set the :preferred_envs for "def cli" if you are running tests from within another command'
  def cli do
    [
      preferred_envs: ["belodon.test": :test]
    ]
  end
end
