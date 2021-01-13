defmodule AssignmentWeb.GraphQL.Schema.WeatherInfoTypes do
  @moduledoc """
    GraphQL Schema Types for Weather Info

    Stayed true to the openweatherAPI response to prevent any data transformation in the backend side
    and may cause discrepancies when debugging.

    Did not add all the objects as it can be added upon request.
  """
  use Absinthe.Schema.Notation

  @desc "Main weather description"
  object :weather do
    field :id, :float
    field :main, :string
    field :description, :string
    field :icon, :string
  end

  @desc "Weather on the daily basis"
  object :daily do
    field :dt, :float
    field :sunrise, :float
    field :sunset, :float
    field :pressure, :float
    field :dew_point, :float
    field :wind_speed, :float
    field :wind_gust, :float
    field :wind_deg, :float
    field :clouds, :float
    field :uvi, :float
    field :pop, :float
    field :humidity, :float
    field :temp, :temperature
    field :feels_like, :feels_like
    field :weather, :weather
  end

  @desc "Temperature details"
  object :temperature do
    field :day, :float
    field :min, :float
    field :max, :float
    field :night, :float
    field :eve, :float
    field :morn, :float
  end

  @desc "This accounts for the human perception of weather"
  object :feels_like do
    field :day, :float
    field :night, :float
    field :eve, :float
    field :morn, :float
  end
end
