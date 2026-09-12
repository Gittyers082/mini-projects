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

  }

end
