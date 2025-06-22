defmodule PreciderWeb.ProductDetailLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

  @impl true
  def mount(%{"id" => product_id}, _session, socket) do
    case Integer.parse(product_id) do
      {id, ""} ->
        case Catalog.get_product(id) do
          nil ->
            {:ok,
             socket
             |> put_flash(:error, "Product not found")
             |> push_navigate(to: ~p"/product_finder")}

          product ->
            {:ok,
             socket
             |> assign(:page_title, product.name)
             |> assign(:product, product)
             |> assign(
               :sorted_ingredients,
               sort_ingredients_by_dosage(product.product_ingredients)
             )
             |> assign(:description_expanded, false)}
        end

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "Invalid product ID")
         |> push_navigate(to: ~p"/product_finder")}
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "No product specified")
     |> push_navigate(to: ~p"/product_finder")}
  end

  @impl true
  def handle_event("toggle_description", _params, socket) do
    {:noreply, update(socket, :description_expanded, &(!&1))}
  end

  defp sort_ingredients_by_dosage(product_ingredients) do
    product_ingredients
    |> Enum.sort_by(fn pi ->
      # Convert all dosages to milligrams for consistent sorting
      dosage_in_mg = convert_to_mg(pi.dosage_amount, pi.dosage_unit)
      # Negative for descending order (highest first)
      -dosage_in_mg
    end)
  end

  defp convert_to_mg(dosage_amount, dosage_unit) do
    amount = Decimal.to_float(dosage_amount)

    case dosage_unit do
      :mg -> amount
      :g -> amount * 1000
      :mcg -> amount / 1000
      _ -> amount
    end
  end

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
      "$#{:io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()}"
    else
      nil
    end
  end

  defp build_ingredient_tooltip(ingredient) do
    parts = []

    # Add category if present
    parts =
      if ingredient.category && ingredient.category != "" do
        category_name = ingredient.category |> String.replace("_", " ") |> String.capitalize()
        category_badge = build_category_badge(ingredient.category, category_name)
        [category_badge | parts]
      else
        parts
      end

    # Add description if present
    parts =
      if ingredient.description && ingredient.description != "" do
        [ingredient.description | parts]
      else
        parts
      end

    # Add benefits if present
    parts =
      if ingredient.benefits && ingredient.benefits != "" do
        ["✨ Benefits: #{ingredient.benefits}" | parts]
      else
        parts
      end

    # Join with line breaks and separators, or return default if no info available
    case parts do
      [] ->
        "No additional information available"

      [single] ->
        single

      _ ->
        parts
        |> Enum.reverse()
        |> Enum.join("\n\n")
    end
  end

  defp build_category_badge(category, category_name) do
    emoji = category_emoji(category)
    "#{emoji} #{category_name}"
  end

  defp category_emoji(category) do
    case category do
      "energy" -> "⚡"
      "focus" -> "🧠"
      "pump" -> "💪"
      "strength" -> "🏋️"
      "endurance" -> "🏃"
      "fat_loss" -> "🔥"
      _ -> "🏷️"
    end
  end

  defp should_truncate_description?(description) do
    description && String.length(description) > 300
  end

  defp truncate_description(description) do
    if String.length(description) > 300 do
      description
      |> String.slice(0, 300)
      |> String.trim()
      |> Kernel.<>("...")
    else
      description
    end
  end
end
