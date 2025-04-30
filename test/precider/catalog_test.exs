defmodule Precider.CatalogTest do
  use Precider.DataCase

  alias Precider.Catalog

  describe "brands" do
    alias Precider.Catalog.Brand

    import Precider.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_brands/0 returns all brands" do
      brand = brand_fixture()
      assert Catalog.list_brands() == [brand]
    end

    test "get_brand!/1 returns the brand with given id" do
      brand = brand_fixture()
      assert Catalog.get_brand!(brand.id) == brand
    end

    test "create_brand/1 with valid data creates a brand" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Brand{} = brand} = Catalog.create_brand(valid_attrs)
      assert brand.name == "some name"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Brand{} = brand} = Catalog.update_brand(brand, update_attrs)
      assert brand.name == "some updated name"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_brand(brand, @invalid_attrs)
      assert brand == Catalog.get_brand!(brand.id)
    end

    test "delete_brand/1 deletes the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{}} = Catalog.delete_brand(brand)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_brand!(brand.id) end
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = Catalog.change_brand(brand)
    end
  end

  describe "ingredients" do
    alias Precider.Catalog.Ingredient

    import Precider.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Catalog.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Catalog.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Ingredient{} = ingredient} = Catalog.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Ingredient{} = ingredient} = Catalog.update_ingredient(ingredient, update_attrs)
      assert ingredient.name == "some updated name"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Catalog.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Catalog.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Catalog.change_ingredient(ingredient)
    end
  end

  describe "products" do
    alias Precider.Catalog.Product

    import Precider.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end

  describe "product_ingredients" do
    alias Precider.Catalog.ProductIngredient

    import Precider.CatalogFixtures

    @invalid_attrs %{dosage_amount: nil}

    test "list_product_ingredients/0 returns all product_ingredients" do
      product_ingredient = product_ingredient_fixture()
      assert Catalog.list_product_ingredients() == [product_ingredient]
    end

    test "get_product_ingredient!/1 returns the product_ingredient with given id" do
      product_ingredient = product_ingredient_fixture()
      assert Catalog.get_product_ingredient!(product_ingredient.id) == product_ingredient
    end

    test "create_product_ingredient/1 with valid data creates a product_ingredient" do
      valid_attrs = %{dosage_amount: "120.5"}

      assert {:ok, %ProductIngredient{} = product_ingredient} = Catalog.create_product_ingredient(valid_attrs)
      assert product_ingredient.dosage_amount == Decimal.new("120.5")
    end

    test "create_product_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product_ingredient(@invalid_attrs)
    end

    test "update_product_ingredient/2 with valid data updates the product_ingredient" do
      product_ingredient = product_ingredient_fixture()
      update_attrs = %{dosage_amount: "456.7"}

      assert {:ok, %ProductIngredient{} = product_ingredient} = Catalog.update_product_ingredient(product_ingredient, update_attrs)
      assert product_ingredient.dosage_amount == Decimal.new("456.7")
    end

    test "update_product_ingredient/2 with invalid data returns error changeset" do
      product_ingredient = product_ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product_ingredient(product_ingredient, @invalid_attrs)
      assert product_ingredient == Catalog.get_product_ingredient!(product_ingredient.id)
    end

    test "delete_product_ingredient/1 deletes the product_ingredient" do
      product_ingredient = product_ingredient_fixture()
      assert {:ok, %ProductIngredient{}} = Catalog.delete_product_ingredient(product_ingredient)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product_ingredient!(product_ingredient.id) end
    end

    test "change_product_ingredient/1 returns a product_ingredient changeset" do
      product_ingredient = product_ingredient_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product_ingredient(product_ingredient)
    end
  end
end
