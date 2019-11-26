defmodule WeatherDb do
  require Logger
  import Ecto.Query, warn: false
  alias WeatherDb.{Repo, History}

  @repo Repo

  def delete_history(%History{} = history) do
    @repo.delete(history)
  end

  def insert_history(attrs) do
    %History{}
    |> History.changeset(attrs)
    |> @repo.insert()
  end

  def get_history_between(start_time, end_time) do
    @repo.all(
      from h in History,
      where: h.time >= ^start_time and h.time < ^end_time,
      order_by: [asc: h.time]
    )
  end
end
