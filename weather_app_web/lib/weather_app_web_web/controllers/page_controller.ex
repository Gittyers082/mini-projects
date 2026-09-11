defmodule WeatherAppWebWeb.PageController do
  use WeatherAppWebWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
