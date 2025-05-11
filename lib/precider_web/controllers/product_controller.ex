defmodule PreciderWeb.ProductController do
  use PreciderWeb, :controller

  alias Precider.Catalog
  alias Precider.Catalog.{Product, Ingredient}
  import Ecto.Changeset, only: [traverse_errors: 2]

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, :index, products: products)
  end

  def new(conn, params) do
    changeset = Catalog.change_product(%Product{})
    brands = Catalog.list_brands()
    ingredients = Catalog.list_ingredients()
    
    # Pre-select brand if brand_id is provided
    changeset = if brand_id = params["brand_id"] do
      changeset |> Ecto.Changeset.put_change(:brand_id, brand_id)
    else
      changeset
    end
    
    render(conn, :new,
      changeset: changeset,
      brand_options: Enum.map(brands, &{&1.name, &1.id}),
      ingredients: ingredients,
      selected_ingredient_ids: [],
      ingredient_dosages: %{},
      ingredient_units: %{},
      show_ingredient_modal: false,
      ingredient_changeset: Catalog.change_ingredient(%Ingredient{})
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
          ingredient_units: Map.get(product_params, "ingredient_units", %{}),
          show_ingredient_modal: false,
          ingredient_changeset: Catalog.change_ingredient(%Ingredient{})
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
      ingredient_units: ingredient_units,
      show_ingredient_modal: false,
      ingredient_changeset: Catalog.change_ingredient(%Ingredient{})
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
          ingredient_units: Map.get(product_params, "ingredient_units", %{}),
          show_ingredient_modal: false,
          ingredient_changeset: Catalog.change_ingredient(%Ingredient{})
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

  # Ingredient modal actions
  def open_ingredient_modal(conn, _params) do
    render(conn, :new,
      changeset: Catalog.change_product(%Product{}),
      brand_options: Enum.map(Catalog.list_brands(), &{&1.name, &1.id}),
      ingredients: Catalog.list_ingredients(),
      selected_ingredient_ids: [],
      ingredient_dosages: %{},
      ingredient_units: %{},
      show_ingredient_modal: true,
      ingredient_changeset: Catalog.change_ingredient(%Ingredient{})
    )
  end

  def create_ingredient(conn, %{"ingredient" => ingredient_params, "return_to" => _return_to}) do
    case Catalog.create_ingredient(ingredient_params) do
      {:ok, ingredient} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{success: true, ingredient: ingredient}))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{success: false, errors: translate_errors(changeset)}))
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
