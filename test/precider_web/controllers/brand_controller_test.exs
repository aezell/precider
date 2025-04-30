defmodule PreciderWeb.BrandControllerTest do
  use PreciderWeb.ConnCase

  import Precider.CatalogFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all brands", %{conn: conn} do
      conn = get(conn, ~p"/brands")
      assert html_response(conn, 200) =~ "Listing Brands"
    end
  end

  describe "new brand" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/brands/new")
      assert html_response(conn, 200) =~ "New Brand"
    end
  end

  describe "create brand" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/brands", brand: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/brands/#{id}"

      conn = get(conn, ~p"/brands/#{id}")
      assert html_response(conn, 200) =~ "Brand #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/brands", brand: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Brand"
    end
  end

  describe "edit brand" do
    setup [:create_brand]

    test "renders form for editing chosen brand", %{conn: conn, brand: brand} do
      conn = get(conn, ~p"/brands/#{brand}/edit")
      assert html_response(conn, 200) =~ "Edit Brand"
    end
  end

  describe "update brand" do
    setup [:create_brand]

    test "redirects when data is valid", %{conn: conn, brand: brand} do
      conn = put(conn, ~p"/brands/#{brand}", brand: @update_attrs)
      assert redirected_to(conn) == ~p"/brands/#{brand}"

      conn = get(conn, ~p"/brands/#{brand}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, brand: brand} do
      conn = put(conn, ~p"/brands/#{brand}", brand: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Brand"
    end
  end

  describe "delete brand" do
    setup [:create_brand]

    test "deletes chosen brand", %{conn: conn, brand: brand} do
      conn = delete(conn, ~p"/brands/#{brand}")
      assert redirected_to(conn) == ~p"/brands"

      assert_error_sent 404, fn ->
        get(conn, ~p"/brands/#{brand}")
      end
    end
  end

  defp create_brand(_) do
    brand = brand_fixture()

    %{brand: brand}
  end
end
