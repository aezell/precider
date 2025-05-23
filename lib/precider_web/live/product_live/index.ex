defmodule PreciderWeb.ProductLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

  @impl true
  def mount(_params, _session, socket) do
    ingredients = Catalog.list_ingredients()
    products = Catalog.list_products()

    {:ok,
     socket
     |> assign(:page_title, "Listing Products")
     |> assign(:ingredients, ingredients)
     |> assign(:displayed_ingredients, get_displayed_ingredients(products))
     |> assign(:filters, %{
       name: "",
       ingredient_mode: %{},
       dosage_min: %{},
       dosage_max: %{},
       dosage_unit: %{}
     })
     |> stream(:products, products)}
  end

  @impl true
  def handle_event("toggle_accordion", %{"id" => _id}, socket) do
    # This is a no-op handler that prevents the form from submitting
    # The accordion toggle is handled by the checkbox's peer class
    {:noreply, socket}
  end

  @impl true
  def handle_event("filter", params, socket) do
    current_filters = socket.assigns.filters
    new_ingredient_mode = parse_ingredient_mode_params(params["ingredient_mode"] || %{})
    
    # Merge new ingredient mode with existing ones
    ingredient_mode = Map.merge(current_filters.ingredient_mode, new_ingredient_mode)
    
    filters = %{
      name: params["name"] || "",
      ingredient_mode: ingredient_mode,
      dosage_min: parse_dosage_params(params["dosage_min"] || %{}),
      dosage_max: parse_dosage_params(params["dosage_max"] || %{}),
      dosage_unit: parse_dosage_params(params["dosage_unit"] || %{})
    }
    normalized_filters = normalize_ingredient_modes(filters)
    products = Catalog.filter_products(normalized_filters)
    
    {:noreply,
     socket
     |> assign(:filters, normalized_filters)
     |> assign(:displayed_ingredients, get_displayed_ingredients(products))
     |> stream(:products, products, reset: true)}
  end

  @impl true
  def handle_event("dosage_slider_change", %{"ingredient_id" => ingredient_id, "min" => min, "max" => max, "unit" => unit}, socket) do
    ingredient_id = String.to_integer(ingredient_id)
    filters = socket.assigns.filters
    new_filters = %{
      filters |
      dosage_min: Map.put(filters.dosage_min, ingredient_id, min),
      dosage_max: Map.put(filters.dosage_max, ingredient_id, max),
      dosage_unit: Map.put(filters.dosage_unit, ingredient_id, unit)
    }
    normalized_filters = normalize_ingredient_modes(new_filters)
    products = filter_products(Catalog.list_products(), normalized_filters)
    {:noreply,
      socket
      |> assign(:filters, normalized_filters)
      |> stream(:products, products, reset: true)
    }
  end

  @impl true
  def handle_event("clear_filters", _params, socket) do
    products = Catalog.list_products()
    
    {:noreply,
     socket
     |> assign(:filters, %{
       name: "",
       ingredient_mode: %{},
       dosage_min: %{},
       dosage_max: %{},
       dosage_unit: %{}
     })
     |> assign(:displayed_ingredients, get_displayed_ingredients(products))
     |> stream(:products, products, reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  defp parse_ingredient_mode_params(params) do
    params
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      case Integer.parse(key) do
        {id, _} -> Map.put(acc, id, value)
        :error -> acc
      end
    end)
  end

  defp parse_dosage_params(params) do
    params
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      case Integer.parse(key) do
        {id, _} -> Map.put(acc, id, value)
        :error -> acc
      end
    end)
  end

  defp filter_products(products, filters) do
    products
    |> Enum.filter(fn product ->
      name_matches?(product, filters.name) and
        ingredients_match?(product, filters)
    end)
  end

  defp name_matches?(_product, name) when name == "", do: true
  defp name_matches?(product, name), do: String.contains?(String.downcase(product.name), String.downcase(name))

  defp ingredients_match?(product, filters) do
    product_ingredient_ids = Enum.map(product.product_ingredients, & &1.ingredient_id)

    filters.ingredient_mode
    |> Enum.all?(fn {ingredient_id, mode} ->
      has_ingredient = ingredient_id in product_ingredient_ids
      dosage_matches = dosage_matches?(product, ingredient_id, filters)

      case mode do
        "include" -> has_ingredient and dosage_matches
        "exclude" -> not has_ingredient
        _ -> true
      end
    end)
  end

  defp dosage_matches?(product, ingredient_id, filters) do
    case Enum.find(product.product_ingredients, &(&1.ingredient_id == ingredient_id)) do
      nil -> true
      pi ->
        case {filters.dosage_min[ingredient_id], filters.dosage_max[ingredient_id], filters.dosage_unit[ingredient_id]} do
          {nil, nil, nil} -> true
          {min, max, unit} when not is_nil(unit) ->
            dosage = convert_to_mg(pi.dosage_amount, pi.dosage_unit)
            min_dosage = if min && min != "", do: convert_to_mg(Decimal.new(min), String.to_atom(unit)), else: nil
            max_dosage = if max && max != "", do: convert_to_mg(Decimal.new(max), String.to_atom(unit)), else: nil

            cond do
              min_dosage && max_dosage -> dosage >= min_dosage && dosage <= max_dosage
              min_dosage -> dosage >= min_dosage
              max_dosage -> dosage <= max_dosage
              true -> true
            end
          _ -> true
        end
    end
  end

  defp convert_to_mg(amount, unit) do
    case unit do
      :mg -> amount
      :g -> Decimal.mult(amount, Decimal.new("1000"))
      :mcg -> Decimal.div(amount, Decimal.new("1000"))
    end

  end

  defp has_active_filters?(filters, ingredient_id) do
    filters.ingredient_mode[ingredient_id] != nil ||
      filters.dosage_min[ingredient_id] != nil ||
      filters.dosage_max[ingredient_id] != nil ||
      filters.dosage_unit[ingredient_id] != nil
  end

  defp normalize_ingredient_modes(filters) do
    ingredient_mode = filters.ingredient_mode
    dosage_min = filters.dosage_min
    dosage_max = filters.dosage_max
    
    # Only set include mode for ingredients that don't already have a mode
    Enum.reduce(Map.keys(dosage_min) ++ Map.keys(dosage_max), ingredient_mode, fn id, acc ->
      id = if is_binary(id), do: String.to_integer(id), else: id
      cond do
        Map.has_key?(acc, id) -> acc  # Preserve existing mode
        (Map.get(dosage_min, id) not in [nil, ""]) or (Map.get(dosage_max, id) not in [nil, ""]) -> 
          Map.put(acc, id, "include")
        true -> acc
      end
    end)
    |> then(fn new_ingredient_mode -> %{filters | ingredient_mode: new_ingredient_mode} end)
  end

  defp get_displayed_ingredients(products) do
    products
    |> Enum.flat_map(& &1.ingredients)
    |> Enum.uniq_by(& &1.id)
    |> Enum.sort_by(& &1.name)
  end

  defp format_decimal(decimal) when is_nil(decimal), do: "0.00"
  defp format_decimal(decimal) do
    decimal
    |> Decimal.to_float()
    |> :erlang.float_to_binary(decimals: 2)
  end
end


