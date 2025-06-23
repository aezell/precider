defmodule PreciderWeb.HealthController do
  use PreciderWeb, :controller

  def check(conn, _params) do
    # Basic health check - you can add database connectivity check if needed
    json(conn, %{status: "ok", timestamp: DateTime.utc_now()})
  end
end
