defmodule WeatherDb.Repo do
  use Ecto.Repo,
    otp_app: :weather_db,
    adapter: Ecto.Adapters.Postgres
end
