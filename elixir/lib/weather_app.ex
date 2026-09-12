defmodule WeatherApp do
  @base_url "https://api.open-meteo.com/v1/forecast"

  # City Presets
  @cities %{
    "baguio" => {16.4023, 120.5960},
    "manila" => {14.5995, 120.9842},
    "tokyo" => {35.6762, 139.6503},
    "london" => {51.5074, -0.1278},
    "shanghai" => {31.2304, 121.4738},
    "zimbabwe" => {-19.0154, 29.1549}
  }

  def get_weather(lat, lon) do
    url = "#{@base_url}?latitude=#{lat}&longitude=#{lon}&current_weather=true"
    response = Req.get!(url)

    # Return just the current_weather map
    response.body["current_weather"]
  end

  # Translates WMO weather codes into text
  def format_condition(0), do: " Clear sky"
  def format_condition(code) when code in [1, 2, 3], do: " Partly cloudy"
  def format_condition(code) when code in [45, 48], do: " Foggy"
  def format_condition(code) when code in [51, 53, 55], do: " Drizzle"
  def format_condition(code) when code in [61, 63, 65], do: " Rain"
  def format_condition(code) when code in [95, 96, 99], do: " Thunderstorm"
  def format_condition(_unknown), do: " Unknown conditions"

  # Pattern matches directly in the function arguments
  def display_report(city, %{"temperature" => temp, "windspeed" => wind, "weathercode" => code}) do
    IO.puts("\n===============================")
    IO.puts("       WEATHER: #{String.upcase(city)}")
    IO.puts("===============================")
    IO.puts(" Condition : #{format_condition(code)}")
    IO.puts(" Temp      : #{temp}°C")
    IO.puts(" Wind Speed: #{wind} km/h")
    IO.puts("===============================\n")
  end

  # Search Function
  def check_city(city_name) do
    normalized = String.downcase(city_name)

    case Map.fetch(@cities, normalized) do
      {:ok, {lat, lon}} ->
        lat
        |> get_weather(lon)
        |> then(&display_report(city_name, &1))

      :error ->
        IO.puts(" City '#{city_name}' not found in presets.")
    end
  end

  # Loopster Function :)
  def start do
    available = Enum.join(Map.keys(@cities), ", ")
    IO.puts("Available presets: #{available}")

    choice =
      "Enter a city name (or type 'exit'): "
      |> IO.gets()
      |> String.trim()

    if String.downcase(choice) == "exit" do
      IO.puts("Exiting weather app. Take care!")
    else
      check_city(choice)
      start()
    end
  end
end
