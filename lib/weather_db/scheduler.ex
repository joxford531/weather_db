defmodule WeatherDb.Scheduler do
  use Quantum.Scheduler,
  otp_app: :weather_db
end
