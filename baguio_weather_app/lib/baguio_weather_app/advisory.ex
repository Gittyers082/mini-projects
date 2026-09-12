defmodule BaguioWeatherApp.Advisory do
  @moduledoc """
  Handles weather fetching and DepEd-aligned class suspension logic for Baguio City.
  """

  @base_url "https://api.open-meteo.com/v1/forecast"

  # AI-Assisted: A comprehensive map of Baguio City's major areas, risk zones, and campuses
  @locations %{

    # SLU Campuses
    "slu main campus" => {16.4150, 120.5955},
    "slu maryheights (bakakeng)" => {16.3900, 120.5847},
    "slu navy base" => {16.4180, 120.6050},
    "slu gonzaga campus" => {16.4101, 120.5992},

    # Other Major Universities
    "up baguio" => {16.4083, 120.5980},
    "university of baguio (ub)" => {16.4140, 120.5975},
    "university of the cordilleras (uc)" => {16.4111, 120.5960},

    #  Major Landmarks
    "session road (city proper)" => {16.4128, 120.5983},
    "burnham park" => {16.4124, 120.5936},
    "camp john hay" => {16.3986, 120.6106},
    "mines view park" => {16.4192, 120.6264},
    "baguio city public market" => {16.4157, 120.5953},

    #High-Risk Areas & Barrios
    "brgy. city camp lagoon" => {16.4086, 120.5894},
    "brgy. irisan" => {16.4028, 120.5519},
    "loakan airport" => {16.3750, 120.6190},
    "aurora hill" => {16.4252, 120.6033},
    "trancoville" => {16.4222, 120.5997},
    "pacdal" => {16.4155, 120.6122},

    # Neighboring BLISTT Areas
    "la trinidad (benguet capital)" => {16.4550, 120.5875},
    "itogon" => {16.3667, 120.6667}
  }

  def list_locations, do: Map.keys(@locations)

  @doc """
  Evaluates safety based on wind (km/h) and rain (mm).
  This showcases Elixir Pattern Matching and Guard Clauses instead of Java if/else blocks.
  """
  def evaluate_safety(wind, rain) when wind > 61.0 or rain > 15.0 do
    %{
      level: :danger,
      suspension: "All Levels Suspended",
      warning: "High risk of landslides or flash floods. Do not travel."
    }
  end

  def evaluate_safety(wind, rain) when wind > 30.0 or rain > 7.5 do
    %{
      level: :alert,
      suspension: "Pre-school to Senior High Suspended",
      warning: "Moderate risk. Monitor local barangay channels."
    }
  end

  def evaluate_safety(_wind, _rain) do
    %{
      level: :safe,
      suspension: "Classes Regular",
      warning: "Normal weather conditions."
    }
  end

  @doc """
  Main pipeline: Takes a location name, fetches data, and evaluates safety.
  """
  def check_location(location_name) do
    # AI-Assisted: Normalize input to handle case and whitespace variations
    normalized = location_name |> String.downcase() |> String.trim()

    case Map.fetch(@locations, normalized) do
      {:ok, {lat, lon}} ->
        url = "#{@base_url}?latitude=#{lat}&longitude=#{lon}&current_weather=true&hourly=precipitation"

        case Req.get(url) do
          {:ok, %{body: body}} ->
            current = body["current_weather"]
            rain_mm = Enum.at(body["hourly"]["precipitation"] || [0.0], 0)
            wind_kmh = current["windspeed"]
            temp_c = current["temperature"]

            safety = evaluate_safety(wind_kmh, rain_mm)

            {:ok, %{
              name: location_name,
              temp: temp_c,
              wind: wind_kmh,
              rain: rain_mm,
              safety: safety
            }}

            {:error, _} -> {:error, "Failed to fetch weather data."}
        end

        :error ->
          {:error, "Location '#{location_name}' not found in the database."}
    end
  end
end
