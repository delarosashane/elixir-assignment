defmodule Assignment.WeatherAPI do
  @moduledoc """
    API calls in openweathermap.org

    Responses will be processed as body and transformed into atoms

    No need to add validations since the API covers the validations. We just need to process it and return
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.openweathermap.org")

  plug(Tesla.Middleware.JSON)

  @doc """
    API call to get weather based on onecall endpoint with the query parameters
  """
  @spec get_weather(any) :: {:ok, any}
  def get_weather(data) do
    {:ok, %Tesla.Env{:body => body}} =
      get("/data/2.5/onecall",
        query: [lat: data.lat, lon: data.lon, appid: data.appid]
      )

    body
    |> process_resp_body()
    |> process_resp_errors()
  end

  defp process_resp_body(body) do
    body
    |> Jason.encode!()
    |> Jason.decode!(keys: :atoms)
  end

  defp process_resp_errors(body = %{cod: _}), do: {:error, body}
  defp process_resp_errors(body), do: {:ok, body}
end
