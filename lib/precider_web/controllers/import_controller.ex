defmodule PreciderWeb.ImportController do
  use PreciderWeb, :controller

  alias Precider.Catalog

  def index(conn, _params) do
    render(conn, :index)
  end

  def import(conn, %{"headers" => headers_json, "data" => data_json}) do
    headers = Jason.decode!(headers_json)
    data = Jason.decode!(data_json)

    # Process each row of data
    results = Enum.map(data, fn row ->
      # Create a map of header -> value
      row_data = Enum.zip(headers, row) |> Map.new()

      # Extract only the fields we need for ingredients
      ingredient_data = Map.take(row_data, ["name", "description", "benefits"])
      
      # Validate required fields
      if Map.has_key?(ingredient_data, "name") do
        Catalog.create_ingredient(ingredient_data)
      else
        {:error, "Missing required field: name"}
      end
    end)

    # Check if all imports were successful
    if Enum.all?(results, fn
      {:ok, _} -> true
      _ -> false
    end) do
      json(conn, %{status: "success"})
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{status: "error", results: results})
    end
  end
end 