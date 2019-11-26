defmodule WeatherDb.Repo.Migrations.AddRainfallColumn do
  use Ecto.Migration

  def change do
    alter table(:history) do
      add :rainfall, :float
    end
  end
end
