defmodule WeatherAppWebWeb.WeatherLive do
  use WeatherAppWebWeb, :live_view
  alias WeatherAppWeb.Weather

  def mount(_params, _session, socket) do
  all_cities = Weather.list_cities()

  {:ok,
   assign(socket,
     all_cities: all_cities,
     filtered_cities: [],
     query: "",
     show_dropdown: false,
     result: nil,
     error: nil,
     loading: false
   )}
end

  def handle_event("suggest_city", %{"city" => query}, socket) do
  trimmed = String.trim(query)

  filtered =
    if trimmed == "" do
      []
    else
      socket.assigns.all_cities
      |> Enum.filter(&String.contains?(String.downcase(&1), String.downcase(trimmed)))
      |> Enum.take(20) # Keeps it fast, even before scrolling
    end

  {:noreply, assign(socket, query: query, filtered_cities: filtered, show_dropdown: length(filtered) > 0)}
end

def handle_event("pick_city", %{"city" => city}, socket) do
  {:noreply, assign(socket, query: city, show_dropdown: false)}
end

def handle_event("check_weather", %{"city" => city}, socket) do
    case Weather.check_city(city) do
      {:ok, city_name, weather} ->
        {:noreply,
         assign(socket,
           result: %{city: city_name, weather: weather},
           error: nil,
           show_dropdown: false,
           loading: false
         )}

      {:error, reason} ->
        {:noreply,
         assign(socket,
           result: nil,
           error: reason,
           show_dropdown: false,
           loading: false
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto mt-10 p-6 bg-white rounded-lg shadow">
      <h1 class="text-2xl text-slate-900 font-bold mb-4">Weather Check</h1>

      <form phx-submit="check_weather" class="mb-6">
        <div class="flex gap-2">
         <!-- Input container with relative positioning for the absolute dropdown -->
         <div class="relative flex-1">
           <input
             type="text"
             name="city"
             value={@query}
             phx-change="suggest_city"
             phx-debounce="150"
             autocomplete="off"
             placeholder="Enter a city..."
             class="w-full bg-gray-50 border-2 border-gray-300 rounded px-3 py-2 text-indigo-600 focus:outline-none focus:border-blue-500"
           />

            <ul
              :if={@show_dropdown and length(@filtered_cities) > 0}
             class="absolute z-50 left-0 right-0 mt-1 max-h-48 overflow-y-auto bg-white border border-gray-200 rounded-md shadow-lg divide-y divide-gray-100"
           >
             <li
               :for={city <- @filtered_cities}
               phx-click="pick_city"
               phx-value-city={city}
               class="px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 cursor-pointer capitalize"
             >
                {city}
             </li>
           </ul>
         </div>

         <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded">
            Check
         </button>
       </div>
      </form>


     <p :if={@loading} class="text-blue-500 font-medium">Loading...</p>

      <div :if={@error} class="text-rose-500 font-semibold mb-4">
       {@error}
      </div>

      <div :if={@result} class="border rounded p-4 bg-gray-50">
       <h2 class="font-semibold text-lg mb-2 text-indigo-700">{String.upcase(@result.city)}</h2>
       <p class="text-slate-600">Condition: {Weather.format_condition(@result.weather["weathercode"])}</p>
       <p class="text-emerald-600 font-bold">Temp: {@result.weather["temperature"]}°C</p>
       <p class="text-sky-600">Wind: {@result.weather["windspeed"]} km/h</p>
     </div>
    </div>
    """
  end
end
