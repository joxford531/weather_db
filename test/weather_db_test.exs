defmodule WeatherDbTest do
  use ExUnit.Case
  doctest WeatherDb

  test "greets the world" do
    assert WeatherDb.hello() == :world
  end
end
