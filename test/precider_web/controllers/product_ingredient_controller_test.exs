defmodule PreciderWeb.ProductIngredientControllerTest do
  use PreciderWeb.ConnCase

  import Precider.CatalogFixtures

  @create_attrs %{dosage_amount: "120.5", dosage_unit: :mg}
  @update_attrs %{dosage_amount: "456.7"}
  @invalid_attrs %{dosage_amount: nil}

  describe "index" do
    test "lists all product_ingredients", %{conn: conn} do
      conn = get(conn, ~p"/product_ingredients")
      assert html_response(conn, 200) =~ "Listing Product ingredients"
    end
  end

  describe "new product_ingredient" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/product_ingredients/new")
      assert html_response(conn, 200) =~ "New Product ingredient"
    end
  end

  describe "create product_ingredient" do
    test "redirects to show when data is valid", %{conn: conn} do
      product = product_fixture()
      ingredient = ingredient_fixture()

      create_attrs =
        @create_attrs
        |> Map.put(:product_id, product.id)
        |> Map.put(:ingredient_id, ingredient.id)

      conn = post(conn, ~p"/product_ingredients", product_ingredient: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/product_ingredients/#{id}"

      conn = get(conn, ~p"/product_ingredients/#{id}")
      assert html_response(conn, 200) =~ "Product ingredient #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/product_ingredients", product_ingredient: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Product ingredient"
    end
  end

  describe "edit product_ingredient" do
    setup [:create_product_ingredient]

    test "renders form for editing chosen product_ingredient", %{
      conn: conn,
      product_ingredient: product_ingredient
    } do
      conn = get(conn, ~p"/product_ingredients/#{product_ingredient}/edit")
      assert html_response(conn, 200) =~ "Edit Product ingredient"
    end
  end

  describe "update product_ingredient" do
    setup [:create_product_ingredient]

    test "redirects when data is valid", %{conn: conn, product_ingredient: product_ingredient} do
      conn =
        put(conn, ~p"/product_ingredients/#{product_ingredient}",
          product_ingredient: @update_attrs
        )

      assert redirected_to(conn) == ~p"/product_ingredients/#{product_ingredient}"

      conn = get(conn, ~p"/product_ingredients/#{product_ingredient}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      product_ingredient: product_ingredient
    } do
      conn =
        put(conn, ~p"/product_ingredients/#{product_ingredient}",
          product_ingredient: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Product ingredient"
    end
  end

  describe "delete product_ingredient" do
    setup [:create_product_ingredient]

    test "deletes chosen product_ingredient", %{
      conn: conn,
      product_ingredient: product_ingredient
    } do
      conn = delete(conn, ~p"/product_ingredients/#{product_ingredient}")
      assert redirected_to(conn) == ~p"/product_ingredients"

      assert_error_sent 404, fn ->
        get(conn, ~p"/product_ingredients/#{product_ingredient}")
      end
    end
  end

  defp create_product_ingredient(_) do
    product_ingredient = product_ingredient_fixture()

    %{product_ingredient: product_ingredient}
  end
end
