defmodule PreciderWeb.PageController do
  use PreciderWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
