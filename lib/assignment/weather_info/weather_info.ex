defmodule Assignment.WeatherInfo do
  @moduledoc """
    Elixir functions to use with the API
  """
  alias Assignment.WeatherAPI

  def get_weather_forecast(input) do
    input
    |> transform_input()
    |> WeatherAPI.get_weather()
  end

  defp transform_input(%{input: input}) do
    %{
      lat: input[:latitude],
      lon: input[:longitude],
      appid: input[:api_key]
    }
  end
end
