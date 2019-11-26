defmodule WeatherDb.Handler do
  use Tortoise.Handler
  require Logger

  def init(args) do
    Logger.info("Handler init")
    {:ok, args}
  end

  def connection(_status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    {:ok, state}
  end

  #  topic filter room/+/temp
  def handle_message(["front", "temp_humidity_dew_point_pressure"], payload, state) do
    %{"humidity" => humidity,
      "temp_sht" => temp_sht,
      "temp_bmp" => temp_bmp,
      "dew_point" => dew_point,
      "pressure" => pressure,
      "rainfall" => rainfall,
      "time" => time,
      "timezone" => timezone,
      "city_id" => city_id
      } = Jason.decode!(payload)

    api_key = Application.get_env(:weather_db, :weather_api_key)

    response = HTTPoison.get!("http://api.openweathermap.org/data/2.5/weather?id=#{city_id}&units=imperial&appid=#{api_key}")

    conditions = case response.status_code do
      200 -> decode_response(response.body)
      _ -> nil
    end

    WeatherDb.insert_history(%{
      sht_temp: temp_sht,
      bmp_temp: temp_bmp,
      humidity: humidity,
      dewpoint: dew_point,
      pressure: pressure,
      time: time,
      timezone: timezone,
      rainfall: rainfall,
      conditions: conditions
    })

    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    Logger.info("unhandled message with topic #{topic}!")
    Logger.info("payload #{inspect(payload)}")
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end

  defp decode_response(body) do
    [%{"description" => description} | _tail] =
    body
      |> Jason.decode!
      |> Map.get("weather")

    description
  end
end
