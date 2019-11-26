defmodule WeatherDb.Repo.Migrations.AddUnitsTable do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string, size: 40

      timestamps()
    end
  end
end
