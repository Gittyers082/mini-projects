defmodule WeatherAppWeb.Weather do
  @base_url "https://api.open-meteo.com/v1/forecast"

  @cities %{
    # NCR Cities
    "manila" => {14.5995, 120.9842},
    "quezon city" => {14.6760, 121.0437},
    "makati" => {14.5547, 121.0244},
    "taguig" => {14.5176, 121.0509},
    "pasig" => {14.5764, 121.0851},
    "mandaluyong" => {14.5794, 121.0359},
    "san juan" => {14.6019, 121.0355},
    "pasay" => {14.5378, 121.0014},
    "parañaque" => {14.4793, 121.0198},
    "las piñas" => {14.4445, 120.9939},
    "muntinlupa" => {14.4081, 121.0415},
    "caloocan" => {14.6488, 120.9782},
    "malabon" => {14.6625, 120.9566},
    "navotas" => {14.6667, 120.9417},
    "valenzuela" => {14.7011, 120.9830},
    "marikina" => {14.6507, 121.1029},

    # Northern & Central Luzon Cities
    "baguio" => {16.4023, 120.5960},
    "laoag" => {18.1960, 120.5927},
    "vigan" => {17.5747, 120.3869},
    "san fernando la union" => {16.6159, 120.3209},
    "dagupan" => {16.0433, 120.3344},
    "urdaneta" => {15.9761, 120.5711},
    "alaminos" => {16.1564, 119.9817},
    "tuguegarao" => {17.6132, 121.7270},
    "ilagan" => {17.1481, 121.8894},
    "cauayan" => {16.9284, 121.7738},
    "santiago" => {16.6917, 121.5492},
    "angeles" => {15.1450, 120.5887},
    "san fernando pampanga" => {15.0340, 120.6853},
    "mabalacat" => {15.2234, 120.5742},
    "tarlac city" => {15.4802, 120.5979},
    "cabanatuan" => {15.4859, 120.9673},
    "gapan" => {15.3089, 120.9507},
    "san jose nueva ecija" => {15.7911, 120.9986},
    "lupao" => {15.8782, 120.8993},
    "palayan" => {15.5414, 121.0844},
    "olongapo" => {14.8386, 120.2842},
    "balanga" => {14.6804, 120.5416},
    "malolos" => {14.8527, 120.8160},
    "meycauayan" => {14.7347, 120.9587},
    "san jose del monte" => {14.8135, 121.0453},

    # Southern Luzon, Bicol & Mimaropa Cities
    "antipolo" => {14.5842, 121.1763},
    "tagaytay" => {14.1153, 120.9621},
    "cavite city" => {14.4830, 120.8986},
    "bacoor" => {14.4624, 120.9645},
    "imus" => {14.4297, 120.9367},
    "dasmariñas" => {14.3294, 120.9367},
    "general trias" => {14.3872, 120.8812},
    "trece martires" => {14.2825, 120.8661},
    "calamba" => {14.2117, 121.1656},
    "santa rosa" => {14.3122, 121.1114},
    "biñan" => {14.3414, 121.0805},
    "cabuyao" => {14.2786, 121.1248},
    "san pablo" => {14.0683, 121.3256},
    "batangas city" => {13.7565, 121.0583},
    "lipa" => {13.9419, 121.1644},
    "tanauan" => {14.0861, 121.1531},
    "lucena" => {13.9314, 121.6172},
    "tayabas" => {14.0253, 121.5936},
    "puerto princesa" => {9.7392, 118.7353},
    "calapan" => {13.4117, 121.1803},
    "naga" => {13.6218, 123.1948},
    "legazpi" => {13.1391, 123.7438},
    "iriga" => {13.4217, 123.4217},
    "ligao" => {13.2411, 123.5350},
    "tabaco" => {13.3592, 123.7314},
    "sorsogon city" => {12.9742, 124.0058},
    "masbate city" => {12.3719, 123.6300},

    # Visayas Cities
    "cebu city" => {10.3157, 123.8854},
    "mandaue" => {10.3333, 123.9333},
    "lapu-lapu" => {10.3111, 123.9494},
    "talisay cebu" => {10.2447, 123.8494},
    "toledo" => {10.3789, 123.6406},
    "carcar" => {10.1067, 123.6439},
    "danao" => {10.5186, 124.0289},
    "naga cebu" => {10.2089, 123.7578},
    "bogo" => {11.0506, 124.0069},
    "iloilo city" => {10.7202, 122.5621},
    "passi" => {11.1072, 122.6417},
    "bacolod" => {10.6765, 122.9509},
    "silay" => {10.7967, 122.9758},
    "talisay negros" => {10.7333, 122.9667},
    "bago" => {10.5378, 122.8378},
    "cadiz" => {10.9578, 123.2867},
    "sagay" => {10.8967, 123.4183},
    "san carlos negros" => {10.4856, 123.4172},
    "kabankalan" => {9.9917, 122.8139},
    "dumaguete" => {9.3068, 123.3054},
    "bais" => {9.5911, 123.1214},
    "bayawan" => {9.3667, 122.8000},
    "guihulngan" => {10.1200, 123.2725},
    "canlaon" => {10.3847, 123.2231},
    "tagbilaran" => {9.6444, 123.8547},
    "roxas city" => {11.5853, 122.7511},
    "tacloban" => {11.2444, 125.0039},
    "ormoc" => {11.0050, 124.6075},
    "baybay" => {10.6781, 124.7986},
    "calbayog" => {12.0667, 124.6000},
    "catbalogan" => {11.7753, 124.8861},
    "borongan" => {11.6075, 125.4319},
    "maasin" => {10.1333, 124.8667},

    # Mindanao Cities
    "davao city" => {7.1907, 125.4553},
    "tagum" => {7.4478, 125.8078},
    "panabo" => {7.3067, 125.6842},
    "samal" => {7.0789, 125.7142},
    "digos" => {6.7581, 125.3564},
    "mati" => {6.9550, 126.2167},
    "cagayan de oro" => {8.4542, 124.6319},
    "iligan" => {8.2280, 124.2452},
    "gingoog" => {8.8211, 125.1017},
    "el salvador" => {8.5636, 124.5244},
    "valencia bukidnon" => {7.9064, 125.0939},
    "malaybalay" => {8.1575, 125.1278},
    "zamboanga city" => {6.9214, 122.0790},
    "pagadian" => {7.8250, 123.4375},
    "dipolog" => {8.5833, 123.3400},
    "dapitan" => {8.6558, 123.4242},
    "isabela city" => {6.7042, 121.9711},
    "general santos" => {6.1164, 125.1716},
    "koronadal" => {6.5028, 124.8472},
    "tacurong" => {6.6908, 124.6739},
    "butuan" => {8.9492, 125.5436},
    "surigao city" => {9.7892, 125.4947},
    "tandag" => {9.0789, 126.1986},
    "bislig" => {8.2125, 126.3150},
    "bayugan" => {8.7119, 125.7481},
    "cotabato city" => {7.2236, 124.2464},
    "marawi" => {8.0033, 124.2858},
    "ozamiz" => {8.1469, 123.8422},
    "tangub" => {8.0647, 123.7511},
    "oroquieta" => {8.4864, 123.8039},

    # Major Global Hubs
    "tokyo" => {35.6762, 139.6503},
    "seoul" => {37.5665, 126.9780},
    "singapore" => {1.3521, 103.8198},
    "bangkok" => {13.7563, 100.5018},
    "hong kong" => {22.3193, 114.1694},
    "taipei" => {25.0330, 121.5654},
    "shanghai" => {31.2304, 121.4738},
    "beijing" => {39.9042, 116.4074},
    "jakarta" => {-6.2088, 106.8456},
    "kuala lumpur" => {3.1390, 101.6869},
    "dubai" => {25.2048, 55.2708},
    "london" => {51.5074, -0.1278},
    "paris" => {48.8566, 2.3522},
    "berlin" => {52.5200, 13.4050},
    "rome" => {41.9028, 12.4964},
    "new york" => {40.7128, -74.0060},
    "los angeles" => {34.0522, -118.2437},
    "toronto" => {43.6532, -79.3832},
    "sydney" => {-33.8688, 151.2093},
    "harare" => {-17.8252, 31.0335}
  }

  def cities, do: Map.keys(@cities)
  def list_cities, do: cities()

  def get_weather(lat, lon) do
    url = "#{@base_url}?latitude=#{lat}&longitude=#{lon}&current_weather=true"

    case Req.get(url) do
      {:ok, %{body: %{"current_weather" => weather}}} -> {:ok, weather}
      {:ok, _} -> {:error, "Unexpected response from weather API"}
      {:error, reason} -> {:error, "Request failed: #{inspect(reason)}"}
    end
  end

  def format_condition(0), do: "Clear sky"
  def format_condition(code) when code in [1, 2, 3], do: "Partly cloudy"
  def format_condition(code) when code in [45, 48], do: "Foggy"
  def format_condition(code) when code in [51, 53, 55], do: "Drizzle"
  def format_condition(code) when code in [61, 63, 65], do: "Rain"
  def format_condition(code) when code in [95, 96, 99], do: "Thunderstorm"
  def format_condition(_unknown), do: "Unknown conditions"

  def check_city(city_name) do
    normalized = city_name |> String.trim() |> String.downcase()

    case Map.fetch(@cities, normalized) do
      {:ok, {lat, lon}} ->
        case get_weather(lat, lon) do
          {:ok, weather} -> {:ok, city_name, weather}
          {:error, reason} -> {:error, reason}
        end

      :error ->
        {:error, "City '#{city_name}' not found in presets."}
    end
  end
end
