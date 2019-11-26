import Config

config :weather_db, WeatherDb.Repo,
  database: System.get_env("DB_DATABASE") || "Weather",
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PW") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  port: System.get_env("DB_PORT") || "5432"

config :weather_db, ecto_repos: [WeatherDb.Repo]

config :weather_db,
  broker_user: System.get_env("MOSQUITTO_USER"),
  broker_password: System.get_env("MOSQUITTO_PW"),
  broker_host: System.get_env("MOSQUITTO_HOST"),
  broker_port: System.get_env("MOSQUITTO_PORT"),
  weather_api_key: System.get_env("WEATHER_API_KEY")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

config :ex_aws,
  json_codec: Jason

config :weather_db, WeatherDb.Scheduler,
  timezone: "America/New_York",
  jobs: [
    # Every 5AM Eastern
    {"0 5 * * *", {WeatherDb.Jobs.Archive, :start_archive, []}},
  ]
