defmodule PreciderWeb.ProductController do
  use PreciderWeb, :controller

  alias Precider.Catalog
  alias Precider.Catalog.Product

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, :index, products: products)
  end

  def new(conn, _params) do
    changeset = Catalog.change_product(%Product{})
    brands = Catalog.list_brands()
    ingredients = Catalog.list_ingredients()
    
    render(conn, :new,
      changeset: changeset,
      brand_options: Enum.map(brands, &{&1.name, &1.id}),
      ingredients: ingredients,
      selected_ingredient_ids: [],
      ingredient_dosages: %{},
      ingredient_units: %{}
    )
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        brands = Catalog.list_brands()
        ingredients = Catalog.list_ingredients()
        
        render(conn, :new,
          changeset: changeset,
          brand_options: Enum.map(brands, &{&1.name, &1.id}),
          ingredients: ingredients,
          selected_ingredient_ids: Map.get(product_params, "ingredient_ids", []),
          ingredient_dosages: Map.get(product_params, "ingredient_dosages", %{}),
          ingredient_units: Map.get(product_params, "ingredient_units", %{})
        )
    end
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    changeset = Catalog.change_product(product)
    brands = Catalog.list_brands()
    ingredients = Catalog.list_ingredients()
    
    # Get existing product ingredients
    product_ingredients = Catalog.get_product_ingredients(product)
    selected_ingredient_ids = Enum.map(product_ingredients, & &1.ingredient_id)
    ingredient_dosages = Map.new(product_ingredients, &{&1.ingredient_id, &1.dosage_amount})
    ingredient_units = Map.new(product_ingredients, &{&1.ingredient_id, &1.dosage_unit})
    
    render(conn, :edit,
      product: product,
      changeset: changeset,
      brand_options: Enum.map(brands, &{&1.name, &1.id}),
      ingredients: ingredients,
      selected_ingredient_ids: selected_ingredient_ids,
      ingredient_dosages: ingredient_dosages,
      ingredient_units: ingredient_units
    )
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Catalog.get_product!(id)

    case Catalog.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        brands = Catalog.list_brands()
        ingredients = Catalog.list_ingredients()
        
        render(conn, :edit,
          product: product,
          changeset: changeset,
          brand_options: Enum.map(brands, &{&1.name, &1.id}),
          ingredients: ingredients,
          selected_ingredient_ids: Map.get(product_params, "ingredient_ids", []),
          ingredient_dosages: Map.get(product_params, "ingredient_dosages", %{}),
          ingredient_units: Map.get(product_params, "ingredient_units", %{})
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    {:ok, _product} = Catalog.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: ~p"/products")
  end
end
