defmodule WeatherDb.Repo.Migrations.AddUnitFkHistory do
  use Ecto.Migration

  def change do
    alter table(:history) do
      add :unit_id, references(:units), default: 1
    end
  end
end
