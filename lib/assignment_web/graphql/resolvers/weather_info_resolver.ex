defmodule AssignmentWeb.GraphQL.Resolvers.WeatherInfoResolver do
  @moduledoc """
    GraphQL resolver for weather info.

    This is where we call functions to be used in mutations and queries
  """
  alias Assignment.WeatherInfo

  def weather_forecast(_root, args, _info) do
    WeatherInfo.get_weather_forecast(args)
  end
end
