defmodule PreciderWeb.ProductIngredientController do
  use PreciderWeb, :controller

  alias Precider.Catalog
  alias Precider.Catalog.ProductIngredient

  def index(conn, _params) do
    product_ingredients = Catalog.list_product_ingredients()
    render(conn, :index, product_ingredients: product_ingredients)
  end

  def new(conn, _params) do
    changeset = Catalog.change_product_ingredient(%ProductIngredient{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"product_ingredient" => product_ingredient_params}) do
    case Catalog.create_product_ingredient(product_ingredient_params) do
      {:ok, product_ingredient} ->
        conn
        |> put_flash(:info, "Product ingredient created successfully.")
        |> redirect(to: ~p"/product_ingredients/#{product_ingredient}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_ingredient = Catalog.get_product_ingredient!(id)
    render(conn, :show, product_ingredient: product_ingredient)
  end

  def edit(conn, %{"id" => id}) do
    product_ingredient = Catalog.get_product_ingredient!(id)
    changeset = Catalog.change_product_ingredient(product_ingredient)
    render(conn, :edit, product_ingredient: product_ingredient, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_ingredient" => product_ingredient_params}) do
    product_ingredient = Catalog.get_product_ingredient!(id)

    case Catalog.update_product_ingredient(product_ingredient, product_ingredient_params) do
      {:ok, product_ingredient} ->
        conn
        |> put_flash(:info, "Product ingredient updated successfully.")
        |> redirect(to: ~p"/product_ingredients/#{product_ingredient}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, product_ingredient: product_ingredient, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_ingredient = Catalog.get_product_ingredient!(id)
    {:ok, _product_ingredient} = Catalog.delete_product_ingredient(product_ingredient)

    conn
    |> put_flash(:info, "Product ingredient deleted successfully.")
    |> redirect(to: ~p"/product_ingredients")
  end
end
