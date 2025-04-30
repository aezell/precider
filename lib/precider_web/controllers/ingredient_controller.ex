defmodule PreciderWeb.IngredientController do
  use PreciderWeb, :controller

  alias Precider.Catalog
  alias Precider.Catalog.Ingredient

  def index(conn, _params) do
    ingredients = Catalog.list_ingredients()
    render(conn, :index, ingredients: ingredients)
  end

  def new(conn, _params) do
    changeset = Catalog.change_ingredient(%Ingredient{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"ingredient" => ingredient_params}) do
    case Catalog.create_ingredient(ingredient_params) do
      {:ok, ingredient} ->
        conn
        |> put_flash(:info, "Ingredient created successfully.")
        |> redirect(to: ~p"/ingredients/#{ingredient}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ingredient = Catalog.get_ingredient!(id)
    render(conn, :show, ingredient: ingredient)
  end

  def edit(conn, %{"id" => id}) do
    ingredient = Catalog.get_ingredient!(id)
    changeset = Catalog.change_ingredient(ingredient)
    render(conn, :edit, ingredient: ingredient, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ingredient" => ingredient_params}) do
    ingredient = Catalog.get_ingredient!(id)

    case Catalog.update_ingredient(ingredient, ingredient_params) do
      {:ok, ingredient} ->
        conn
        |> put_flash(:info, "Ingredient updated successfully.")
        |> redirect(to: ~p"/ingredients/#{ingredient}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, ingredient: ingredient, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ingredient = Catalog.get_ingredient!(id)
    {:ok, _ingredient} = Catalog.delete_ingredient(ingredient)

    conn
    |> put_flash(:info, "Ingredient deleted successfully.")
    |> redirect(to: ~p"/ingredients")
  end
end
