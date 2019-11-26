defmodule WeatherDb.Jobs.Archive do

  def start_archive() do
    yesterday = Date.add(Date.utc_today(), -1)
    WeatherDb.Pipeline.ArchiveProducer.archive_date(yesterday)
  end
end
