defmodule AssignmentWeb.GraphQl.SchemaTest do
  @moduledoc """
    GraphQL schema tests
  """
  use AssignmentWeb.ConnCase

  use ExUnit.Case, async: false

  import Tesla.Mock

  describe "One Call API Weather Info" do
    test "With valid parameters", %{conn: conn} do
      mock(fn
        %{method: :get, url: "https://api.openweathermap.org/data/2.5/onecall"} ->
          %Tesla.Env{status: 200, body: body()}
      end)

      query = """
      {
        weather_forecast(input: #{params_to_string(params())})
        {
          current {
            dt
            sunrise
            sunset
          }
        }
      }
      """

      res =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      data = res["data"]

      assert data == %{
               "weather_forecast" => %{
                 "current" => %{
                   "sunrise" => 1_610_544_020,
                   "sunset" => 1_610_580_551,
                   "dt" => 1_610_555_132
                 }
               }
             }
    end

    test "with invalid api key", %{conn: conn} do
      mock(fn
        %{method: :get, url: "https://api.openweathermap.org/data/2.5/onecall"} ->
          %Tesla.Env{status: 200, body: error_body("401")}
      end)

      query = """
      {
        weather_forecast(input: #{params_to_string(params(:api_key, "test123"))})
        {
          current {
            dt
            sunrise
            sunset
          }
        }
      }
      """

      res =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      error = List.first(res["errors"])

      assert error["cod"] == "401"

      assert error["message"] ==
               "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."
    end

    test "with invalid latitude", %{conn: conn} do
      mock(fn
        %{method: :get, url: "https://api.openweathermap.org/data/2.5/onecall"} ->
          %Tesla.Env{status: 200, body: error_body("400")}
      end)

      query = """
      {
        weather_forecast(input: #{params_to_string(params(:latitude, "asdas"))})
        {
          current {
            dt
            sunrise
            sunset
          }
        }
      }
      """

      res =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      error = List.first(res["errors"])

      assert error["cod"] == "400"

      assert error["message"] ==
               "wrong latitude"
    end
  end

  defp params() do
    %{
      latitude: "33.441792",
      longitude: "-94.037689",
      api_key: "cf952afbbe7fd136bd77c9c2a7e614cb"
    }
  end

  defp params(key, value) do
    Map.put(params(), key, value)
  end

  defp params_to_string(params) do
    str = Enum.map_join(params, ", ", fn {key, val} -> ~s(#{key}: "#{val}") end)

    "{#{str}}"
  end

  defp error_body(code) when code == "401" do
    %{
      "cod" => "401",
      "message" =>
        "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."
    }
  end

  defp error_body(code) when code == "400" do
    %{
      "cod" => "400",
      "message" => "wrong latitude"
    }
  end

  defp body() do
    %{
      "current" => %{
        "clouds" => 1,
        "dew_point" => 274.85,
        "dt" => 1_610_555_132,
        "feels_like" => 275.69,
        "humidity" => 70,
        "pressure" => 1022,
        "sunrise" => 1_610_544_020,
        "sunset" => 1_610_580_551,
        "temp" => 279.93,
        "uvi" => 1.39,
        "visibility" => 10000,
        "weather" => [
          %{
            "description" => "clear sky",
            "icon" => "01d",
            "id" => 800,
            "main" => "Clear"
          }
        ],
        "wind_deg" => 220,
        "wind_speed" => 3.6
      },
      "daily" => [
        %{
          "clouds" => 0,
          "dew_point" => 275.72,
          "dt" => 1_610_560_800,
          "feels_like" => %{
            "day" => 278.03,
            "eve" => 277.13,
            "morn" => 270.72,
            "night" => 274.34
          },
          "humidity" => 65,
          "pop" => 0,
          "pressure" => 1021,
          "sunrise" => 1_610_544_020,
          "sunset" => 1_610_580_551,
          "temp" => %{
            "day" => 281.93,
            "eve" => 280.58,
            "max" => 284.99,
            "min" => 273.81,
            "morn" => 274.06,
            "night" => 278.49
          },
          "uvi" => 2.58,
          "weather" => [
            %{
              "description" => "clear sky",
              "icon" => "01d",
              "id" => 800,
              "main" => "Clear"
            }
          ],
          "wind_deg" => 232,
          "wind_speed" => 3.32
        }
      ]
    }
  end
end
