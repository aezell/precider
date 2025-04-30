defmodule Precider.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Precider.Catalog` context.
  """

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    {:ok, brand} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Precider.Catalog.create_brand()

    brand
  end

  @doc """
  Generate a ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Precider.Catalog.create_ingredient()

    ingredient
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Precider.Catalog.create_product()

    product
  end

  @doc """
  Generate a product_ingredient.
  """
  def product_ingredient_fixture(attrs \\ %{}) do
    {:ok, product_ingredient} =
      attrs
      |> Enum.into(%{
        dosage_amount: "120.5"
      })
      |> Precider.Catalog.create_product_ingredient()

    product_ingredient
  end
end
