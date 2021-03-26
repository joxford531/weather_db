defmodule WeatherDb.Pipeline.ArchiveHandler do
  use GenStage
  use Timex
  alias ExAws.S3

  @write_path = "./persist"

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:consumer, :ok, subscribe_to: [{WeatherDb.Pipeline.ArchiveProducer, max_demand: 1}]}
  end

  def handle_events([date], _from, state) do
    start = Timex.to_datetime(date, "America/New_York")
    finish =
      Date.add(date, 1)
      |> Timex.to_datetime("America/New_York")

    write_csv(start, finish)

    {:noreply, [], state}
  end

  defp write_csv(start, finish) do
    rows = WeatherDb.get_history_between(start, finish)

    formatted_results = Enum.map(rows, fn row ->
      "#{row.time},#{row.timezone},#{row.bmp_temp},#{row.sht_temp},#{row.humidity},"
      <> "#{row.dewpoint},#{row.pressure},#{row.conditions || 'none'},#{row.unit_id},#{row.rainfall || 0}" end)

    formatted_results =
      ["Time, Timezone, Bmp180 Temp, SHT31-d Temp, Humidity, Dewpoint, Pressure, Conditions, Unit_Id, Rainfall" | formatted_results]

    {:ok, date} = Timex.format(start, "%Y-%m-%d", :strftime)

    path = @write_path <> "/" date <> ".csv"

    if File.exists?(@write_path) == false do
      File.mkdir!(@write_path)
    end

    File.write!(path, Enum.join(formatted_results, "\r\n"), [:utf8])

    upload_s3(path, date)
  end

  defp upload_s3(path, date) do
    {:ok, _result} =
      path |>
      S3.Upload.stream_file |>
      S3.upload("personal-joxford", "weather/" <> date <> ".csv") |>
      ExAws.request

    File.rm!(path)
  end
end
