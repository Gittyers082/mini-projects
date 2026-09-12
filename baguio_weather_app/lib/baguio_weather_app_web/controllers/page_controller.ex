defmodule BaguioWeatherAppWeb.PageController do
  use BaguioWeatherAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
