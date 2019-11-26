defmodule WeatherDb.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_db,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WeatherDb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tortoise, "~> 0.9"},
      {:jason, "~> 1.1"},
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, "~> 0.14.1"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.6"},
      {:httpoison, "~> 1.5"},
      {:gen_stage, "~> 0.14"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"}
    ]
  end
end
