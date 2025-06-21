defmodule PreciderWeb.ProductComparisonLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

  @impl true
  def mount(%{"products" => product_ids_param}, _session, socket) do
    product_ids =
      product_ids_param
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      # Limit to 4 products for display
      |> Enum.take(4)

    products =
      product_ids
      |> Enum.map(&Catalog.get_product!/1)
      |> Enum.filter(&(!is_nil(&1)))

    if length(products) < 2 do
      {:ok,
       socket
       |> put_flash(:error, "At least 2 products are required for comparison")
       |> push_navigate(to: ~p"/pre-chooser")}
    else
      {:ok,
       socket
       |> assign(:page_title, "Product Comparison")
       |> assign(:products, products)
       |> assign(:aligned_ingredients, build_aligned_ingredients(products))}
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "No products specified for comparison")
     |> push_navigate(to: ~p"/pre-chooser")}
  end

  @impl true
  def handle_event("back_to_chooser", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/pre-chooser")}
  end

  defp build_aligned_ingredients(products) do
    # Get all unique ingredients across all products
    all_ingredients =
      products
      |> Enum.flat_map(fn product ->
        Enum.map(product.product_ingredients, & &1.ingredient)
      end)
      |> Enum.uniq_by(& &1.id)
      |> Enum.sort_by(&String.downcase(&1.name))

    # For each ingredient, create a map showing which products have it and their dosages
    Enum.map(all_ingredients, fn ingredient ->
      product_data =
        Enum.map(products, fn product ->
          product_ingredient =
            Enum.find(product.product_ingredients, fn pi ->
              pi.ingredient.id == ingredient.id
            end)

          %{
            product: product,
            product_ingredient: product_ingredient,
            has_ingredient: !is_nil(product_ingredient)
          }
        end)

      %{
        ingredient: ingredient,
        product_data: product_data,
        present_in_count: Enum.count(product_data, & &1.has_ingredient)
      }
    end)
    |> Enum.sort_by(fn item ->
      # Sort by: ingredients present in most products first, then alphabetically
      {-item.present_in_count, String.downcase(item.ingredient.name)}
    end)
  end

  defp format_dosage(nil), do: nil

  defp format_dosage(product_ingredient) do
    amount = Decimal.to_float(product_ingredient.dosage_amount)
    unit = product_ingredient.dosage_unit

    case unit do
      :mg when amount >= 1000 -> "#{amount / 1000}g"
      :mg -> "#{format_number(amount)}mg"
      :g -> "#{format_number(amount)}g"
      :mcg when amount >= 1000 -> "#{amount / 1000}mg"
      :mcg -> "#{format_number(amount)}mcg"
      _ -> "#{format_number(amount)}#{unit}"
    end
  end

  defp format_number(number) when is_float(number) do
    if number == Float.round(number, 0) do
      "#{trunc(number)}"
    else
      "#{Float.round(number, 1)}"
    end
  end

  defp format_price(price) when is_nil(price), do: "N/A"

  defp format_price(price) do
    amount = Decimal.to_float(price)
    "$#{:io_lib.format("~.2f", [amount]) |> IO.iodata_to_binary()}"
  end

  defp format_cost_per_serving(product) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    if not is_nil(product.servings_per_container) and product.servings_per_container > 0 do
      cost_per_serving = price / product.servings_per_container
      "$#{:io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()} per serving"
    else
      nil
    end
  end

  defp ingredient_category_color(category) do
    case category do
      "energy" -> "text-red-600 bg-red-50"
      "focus" -> "text-blue-600 bg-blue-50"
      "pump" -> "text-pink-600 bg-pink-50"
      "strength" -> "text-green-600 bg-green-50"
      "endurance" -> "text-purple-600 bg-purple-50"
      "fat_loss" -> "text-orange-600 bg-orange-50"
      _ -> "text-gray-600 bg-gray-50"
    end
  end
end
