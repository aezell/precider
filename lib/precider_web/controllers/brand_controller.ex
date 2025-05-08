defmodule PreciderWeb.BrandController do
  use PreciderWeb, :controller

  alias Precider.Catalog
  alias Precider.Catalog.Brand

  def index(conn, params) do
    sort_by = String.to_existing_atom(params["sort_by"] || "name")
    sort_direction = String.to_existing_atom(params["sort_direction"] || "asc")
    
    brands = Catalog.list_brands(sort_by: sort_by, sort_direction: sort_direction)
    render(conn, :index, brands: brands)
  end

  def new(conn, _params) do
    changeset = Catalog.change_brand(%Brand{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"brand" => brand_params, "save_and_new" => "true"}) do
    case Catalog.create_brand(brand_params) do
      {:ok, _brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: ~p"/brands/new")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def create(conn, %{"brand" => brand_params}) do
    case Catalog.create_brand(brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: ~p"/brands/#{brand}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brand = Catalog.get_brand!(id)
    render(conn, :show, brand: brand)
  end

  def edit(conn, %{"id" => id}) do
    brand = Catalog.get_brand!(id)
    changeset = Catalog.change_brand(brand)
    render(conn, :edit, brand: brand, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = Catalog.get_brand!(id)

    case Catalog.update_brand(brand, brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand updated successfully.")
        |> redirect(to: ~p"/brands/#{brand}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, brand: brand, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = Catalog.get_brand!(id)
    {:ok, _brand} = Catalog.delete_brand(brand)

    conn
    |> put_flash(:info, "Brand deleted successfully.")
    |> redirect(to: ~p"/brands")
  end
end
