defmodule BaguioWeatherAppWeb.WeatherLive do
  use BaguioWeatherAppWeb, :live_view
  alias BaguioWeatherApp.Advisory

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
      locations: Advisory.list_locations(),
      filtered_locations: [],
      query: "",
      show_dropdown: false,
      result: nil,
      error: nil,
      loading: false)
    }
  end

  def handle_event("suggest_location", %{"location" => query}, socket) do
    trimmed = String.trim(query)

    filtered =
      if trimmed == "" do
        []
      else
        socket.assigns.locations
        |> Enum.filter(&String.contains?(String.downcase(&1), String.downcase(trimmed)))
        |> Enum.take(20)
      end

      {:noreply, assign(socket, filtered_locations: filtered, query: query, show_dropdown: length(filtered) > 0)}
  end

  def handle_event("pick_location", %{"location" => loc}, socket) do
    {:noreply, assign(socket, query: loc, show_dropdown: false)}
  end

  def handle_event("check_weather", %{"location" => loc}, socket) do
    case Advisory.check_location(loc) do
      {:ok, data} ->
        {:noreply,
         assign(socket, result: data, error: nil, show_dropdown: false, loading: false)}

      {:error, reason} ->
        {:noreply,
         assign(socket, error: reason, result: nil, loading: false, show_dropdown: false)}
    end
  end

  # AI-Assisted: Pattern matching on the UI side to dynamically set Tailwind colors (lines: 49-51)
  defp alert_colors(:danger), do: "bg-red-50 border-red-500 text-red-900"
  defp alert_colors(:alert), do: "bg-amber-50 border-amber-500 text-amber-900"
  defp alert_colors(:safe), do: "bg-emerald-50 border-emerald-500 text-emerald-900"

  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto mt-10 p-6 bg-white rounded-lg shadow-md">
      <h1 class="text-3xl text-slate-900 font-extrabold mb-2">Baguio Advisory System</h1>
      <p class="text-slate-600 mb-6">Real-time weather and DepEd class suspension alerts.</p>

      <form phx-submit="check_weather" class="mb-6">
        <div class="flex gap-2">
          <div class="relative flex-1">
            <input type="text" name="location" value={@query} placeholder="Enter location"
              phx-change="suggest_location" phx-debounce="150" autocomplete="off"
              class="w-full bg-gray-50 border-2 border-gray-300 rounded-lg px-4 py-3 text-indigo-700 focus:outline-none focus:border-indigo-500 font-medium"
            />

            <!-- AI Assisted: Dropdown for location suggestions (lines: 67-80) -->
            <ul
              :if={@show_dropdown and length(@filtered_locations) > 0}
              class="absolute z-50 left-0 right-0 mt-1 max-h-48 overflow-y-auto bg-white border border-gray-200 rounded-md shadow-lg divide-y divide-gray-100"
            >
              <li
                :for={loc <- @filtered_locations}
                phx-click="pick_location"
                phx-value-location={loc}
                class="px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-700 cursor-pointer capitalize"
              >
                {loc}
              </li>
            </ul>
          </div>

          <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-6 py-3 rounded-lg shadow-sm transition-colors">
            Check
          </button>
        </div>
      </form>

      <div :if={@error} class="text-red-600 font-semibold mb-4 p-3 bg-red-50 rounded border border-red-200">
        {@error}
      </div>

      <!-- AI-Assisted: Result Card (lines: 95 - 101) -->
      <div :if={@result} class={"border-l-4 rounded-r-lg p-5 shadow-sm " <> alert_colors(@result.safety.level)}>
        <div class="flex justify-between items-start mb-4">
          <h2 class="font-bold text-xl capitalize">{@result.name}</h2>
          <span class="px-3 py-1 bg-white/60 rounded-full text-sm font-bold uppercase tracking-wider">
            {@result.safety.level}
          </span>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4 text-sm bg-white/40 p-3 rounded">
          <div>
            <span class="block opacity-75 font-semibold">Temperature</span>
            <span class="text-lg font-bold">{@result.temp}°C</span>
          </div>
          <div>
            <span class="block opacity-75 font-semibold">Rain / Wind</span>
            <span class="text-lg font-bold">{@result.rain} mm / {@result.wind} km/h</span>
          </div>
        </div>

        <div class="pt-3 border-t border-black/10">
          <p class="font-bold text-lg mb-1">{@result.safety.suspension}</p>
          <p class="opacity-90 leading-tight">{@result.safety.warning}</p>
        </div>
      </div>
    </div>
    """
  end
end
