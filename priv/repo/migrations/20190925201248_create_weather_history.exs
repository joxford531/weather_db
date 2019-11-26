defmodule WeatherDb.Repo.Migrations.CreateWeatherHistory do
  use Ecto.Migration

  def change do
    create table(:history, primary_key: false) do
      add :time, :utc_datetime, primary_key: true
      add :timezone, :string
      add :bmp_temp, :float
      add :sht_temp, :float
      add :humidity, :float
      add :dewpoint, :float
      add :pressure, :float
      add :conditions, :string
    end
  end
end
