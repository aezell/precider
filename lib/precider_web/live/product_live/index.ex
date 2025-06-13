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
     |> assign(:drawer_open, false)
     |> assign(:ingredient_search_query, "")
     |> assign(:ingredient_search_results, [])
     |> assign(:active_ingredient_filters, [])
     |> stream(:products, products)}
  end

  @impl true
  def handle_event("open_drawer", _params, socket) do
    {:noreply, assign(socket, :drawer_open, true)}
  end

  @impl true
  def handle_event("close_drawer", _params, socket) do
    {:noreply, assign(socket, :drawer_open, false)}
  end

  @impl true
  def handle_event("update_ingredient_search", %{"ingredient_search_query" => query}, socket) do
    results =
      socket.assigns.ingredients
      |> Enum.filter(fn ing ->
        String.contains?(String.downcase(ing.name), String.downcase(query))
      end)
      |> Enum.take(10)

    {:noreply, assign(socket, ingredient_search_query: query, ingredient_search_results: results)}
  end

  @impl true
  def handle_event("select_ingredient", %{"id" => id}, socket) do
    ingredient_id = String.to_integer(id)
    active_filters = socket.assigns.active_ingredient_filters
    if Enum.any?(active_filters, &(&1.ingredient_id == ingredient_id)) do
      {:noreply,
        socket
        |> assign(:ingredient_search_query, "")
        |> assign(:ingredient_search_results, [])}
    else
      new_filter = %{ingredient_id: ingredient_id, mode: "include", min: nil, max: nil, unit: "mg"}
      {:noreply,
        socket
        |> assign(:active_ingredient_filters, [new_filter | active_filters])
        |> assign(:ingredient_search_query, "")
        |> assign(:ingredient_search_results, [])
        |> maybe_update_products()}
    end
  end

  @impl true
  def handle_event("update_ingredient_filter", %{"ingredient_id" => id, "mode" => mode}, socket) do
    ingredient_id = String.to_integer(id)
    active_filters = socket.assigns.active_ingredient_filters
    updated_filters = Enum.map(active_filters, fn filter ->
      if filter.ingredient_id == ingredient_id do
        Map.put(filter, :mode, mode)
      else
        filter
      end
    end)
    {:noreply, socket |> assign(:active_ingredient_filters, updated_filters) |> maybe_update_products()}
  end

  @impl true
  def handle_event("update_ingredient_filter", %{"ingredient_id" => id} = params, socket) do
    ingredient_id = String.to_integer(id)
    active_filters = socket.assigns.active_ingredient_filters
    updated_filters = Enum.map(active_filters, fn filter ->
      if filter.ingredient_id == ingredient_id do
        Map.merge(filter, Map.take(params, ["mode", "min", "max", "unit"]))
        |> Map.update("min", nil, &parse_optional_decimal/1)
        |> Map.update("max", nil, &parse_optional_decimal/1)
      else
        filter
      end
    end)
    {:noreply, socket |> assign(:active_ingredient_filters, updated_filters) |> maybe_update_products()}
  end

  @impl true
  def handle_event("remove_ingredient_filter", %{"ingredient_id" => id}, socket) do
    ingredient_id = String.to_integer(id)
    updated_filters = Enum.reject(socket.assigns.active_ingredient_filters, &(&1.ingredient_id == ingredient_id))
    {:noreply, socket |> assign(:active_ingredient_filters, updated_filters) |> maybe_update_products()}
  end

  @impl true
  def handle_event("clear_all_ingredient_filters", _params, socket) do
    {:noreply, socket |> assign(:active_ingredient_filters, []) |> maybe_update_products()}
  end

  @impl true
  def handle_info({:update_products}, socket) do
    products = filter_products(Catalog.list_products(), socket.assigns.active_ingredient_filters)
    {:noreply,
      socket
      |> assign(:displayed_ingredients, get_displayed_ingredients(products))
      |> stream(:products, products, reset: true)}
  end

  defp filter_products(products, ingredient_filters) do
    products
    |> Enum.filter(fn product ->
      ingredient_filters
      |> Enum.all?(fn filter ->
        ingredient_id = filter.ingredient_id
        mode = Map.get(filter, "mode") || Map.get(filter, :mode)
        min = Map.get(filter, "min") || Map.get(filter, :min)
        max = Map.get(filter, "max") || Map.get(filter, :max)
        unit = Map.get(filter, "unit") || Map.get(filter, :unit)
        has_ingredient = Enum.any?(product.product_ingredients, &(&1.ingredient_id == ingredient_id))
        dosage_matches = dosage_matches?(product, ingredient_id, min, max, unit)
        case mode do
          "include" -> has_ingredient and dosage_matches
          "exclude" -> not has_ingredient
          _ -> true
        end
      end)
    end)
  end

  defp dosage_matches?(product, ingredient_id, min, max, unit) do
    case Enum.find(product.product_ingredients, &(&1.ingredient_id == ingredient_id)) do
      nil -> true
      pi ->
        cond do
          is_nil(min) and is_nil(max) -> true
          not is_nil(unit) ->
            dosage = convert_to_mg(pi.dosage_amount, pi.dosage_unit)
            min_dosage = if min && min != "", do: convert_to_mg(Decimal.new(min), String.to_atom(unit)), else: nil
            max_dosage = if max && max != "", do: convert_to_mg(Decimal.new(max), String.to_atom(unit)), else: nil
            cond do
              min_dosage && max_dosage -> dosage >= min_dosage && dosage <= max_dosage
              min_dosage -> dosage >= min_dosage
              max_dosage -> dosage <= max_dosage
              true -> true
            end
          true -> true
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

  defp parse_optional_decimal(nil), do: nil
  defp parse_optional_decimal(""), do: nil
  defp parse_optional_decimal(val), do: val

  defp maybe_update_products(socket) do
    send(self(), {:update_products})
    socket
  end
end


