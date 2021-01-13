defmodule AssignmentWeb.GraphQL.Schema do
  @moduledoc """
    GraphQL Schema for Weather API

    Added api_key, exclude, lang, units as inputs for further client testing with their API keys and other args
  """

  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(AssignmentWeb.GraphQL.Schema.WeatherInfoTypes)

  alias AssignmentWeb.GraphQL.Resolvers.WeatherInfoResolver

  @desc "Defines the weather forecast"
  object :weather_forecast do
    field :current, :current
    field :daily, list_of(:daily)
    field :lat, :float
    field :lon, :float
    field :timezone, :string
    field :timezone_offset, :integer
  end

  object :current do
    field :dt, :float
    field :sunrise, :float
    field :sunset, :float
    field :weather, list_of(:weather)
    field :daily, list_of(:daily)
    field :temp, :float
    field :feels_like, :float
    field :clouds, :float
    field :dew_point, :float
    field :humidity, :float
    field :pressure, :float
    field :uvi, :float
    field :visibility, :float
    field :wind_deg, :float
    field :wind_speed, :float
    field :wind_gust, :float
  end

  @desc """
    Coordinate input for the forecast.

    Added api key as input for client testing with their API keys. Can be removed upon request.

    All input types are strings as for usability especially in query types in an API
  """
  input_object :coordinate_input do
    field :latitude, non_null(:string)
    field :longitude, non_null(:string)
    field :api_key, non_null(:string)
    field :exclude, :string
    field :lang, :string
    field :units, :string
  end

  query do
    @desc "Returns Weather forecast based on input"
    field :weather_forecast, :weather_forecast do
      arg(:input, non_null(:coordinate_input))

      resolve(&WeatherInfoResolver.weather_forecast/3)
    end
  end
end
