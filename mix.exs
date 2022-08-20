defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      name: "GitHub Issues CLI",
      source_url: "https://github.com/amos-kibet/github-issues-cli",
      version: "0.1.0",
      elixir: "~> 1.13",
      escript: escript_config(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # hhtp client
      {:httpoison, "~> 1.0.0"},
      # json parser
      {:poison, "~> 3.1"},
      # for project documentation
      {:ex_doc, "~> 0.28.5"},
      # markdown to html converter
      {:earmark, "~> 1.4"}
    ]
  end

  defp escript_config do
    [
      main_module: Issues.CLI
    ]
  end
end
