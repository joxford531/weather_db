defmodule WeatherDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      WeatherDb.Repo,
      WeatherDb.Pipeline.ArchiveProducer,
      WeatherDb.Pipeline.ArchiveHandler,
      WeatherDb.Scheduler
    ]

    {:ok, _pid} =
      Tortoise.Supervisor.start_child(
        client_id: "weather_sensor_db",
        handler: {WeatherDb.Handler, []},
        user_name: Application.get_env(:weather_db, :broker_user) || System.get_env("BROKER_USER"),
        password: Application.get_env(:weather_db, :broker_password) || System.get_env("BROKER_PASSWORD"),
        server: {
          Tortoise.Transport.Tcp,
          host: Application.get_env(:weather_db, :broker_host) || System.get_env("BROKER_HOST"),
          port: Application.get_env(:weather_db, :broker_port) |> String.to_integer() ||
            (System.get_env("BROKER_PORT") |> String.to_integer())
        },
        subscriptions: [{"front/temp_humidity_dew_point_pressure", 0}])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherDb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
