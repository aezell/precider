defmodule PreciderWeb.ProductLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Products
        <:actions>
          <.button variant="primary" navigate={~p"/products/new"}>
            <.icon name="hero-plus" /> New Product
          </.button>
        </:actions>
      </.header>

      <div class="flex gap-4">
        <!-- Filter Panel -->
        <div class="w-64 bg-base-200 p-4 rounded-lg">
          <!-- Name Search Form -->
          <form phx-change="filter" class="mb-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Search by Name</span>
              </label>
              <input
                type="text"
                name="name"
                value={@filters.name}
                placeholder="Search products..."
                class="input input-bordered w-full"
              />
            </div>
          </form>

          <!-- Ingredient Filters -->
          <div class="form-control">
            <label class="label">
              <span class="label-text">Ingredients</span>
            </label>
            <div class="space-y-2">
              <div :for={ingredient <- @ingredients} class="collapse collapse-arrow bg-base-100">
                <input 
                  type="checkbox" 
                  class="peer" 
                  checked={has_active_filters?(@filters, ingredient.id)}
                />
                <div class="collapse-title text-sm font-medium">
                  {ingredient.name}
                </div>
                <div class="collapse-content">
                  <form phx-change="filter" phx-debounce="300" class="form-control space-y-4">
                    <!-- Include/Exclude Toggle -->
                    <div class="flex items-center gap-4">
                      <div class="relative">
                        <input
                          type="radio"
                          name={"ingredient_mode[#{ingredient.id}]"}
                          value="include"
                          checked={@filters.ingredient_mode[ingredient.id] == "include" or (@filters.dosage_min[ingredient.id] not in [nil, ""] or @filters.dosage_max[ingredient.id] not in [nil, ""])}
                          class="hidden peer/include"
                          id={"include-#{ingredient.id}"}
                        />
                        <input
                          type="radio"
                          name={"ingredient_mode[#{ingredient.id}]"}
                          value="exclude"
                          checked={@filters.ingredient_mode[ingredient.id] == "exclude"}
                          class="hidden peer/exclude"
                          id={"exclude-#{ingredient.id}"}
                        />
                        <input
                          type="radio"
                          name={"ingredient_mode[#{ingredient.id}]"}
                          value=""
                          checked={@filters.ingredient_mode[ingredient.id] == nil}
                          class="hidden peer/none"
                          id={"none-#{ingredient.id}"}
                        />
                        <label
                          for={case @filters.ingredient_mode[ingredient.id] do
                            "include" -> "exclude-#{ingredient.id}"
                            "exclude" -> "none-#{ingredient.id}"
                            _ -> "include-#{ingredient.id}"
                          end}
                          class={[
                            "btn btn-sm cursor-pointer",
                            "peer-checked/include:btn-success",
                            "peer-checked/exclude:btn-error",
                            "peer-checked/none:btn-ghost"
                          ]}
                        >
                          <%= case @filters.ingredient_mode[ingredient.id] do %>
                            <% "include" -> %>
                              <.icon name="hero-check" class="h-4 w-4" /> Exclude?
                            <% "exclude" -> %>
                              <.icon name="hero-x-mark" class="h-4 w-4" /> Reset?
                            <% _ -> %>
                              <.icon name="hero-minus" class="h-4 w-4" /> Include?
                          <% end %>
                        </label>
                      </div>
                    </div>

                    <!-- Dosage Range -->
                    <div class="form-control">
                      <label class="label">
                        <span class="label-text text-sm">Dosage Range</span>
                      </label>
                      <div class="flex items-center gap-2">
                        <input
                          type="number"
                          name={"dosage_min[#{ingredient.id}]"}
                          value={@filters.dosage_min[ingredient.id]}
                          placeholder="Min"
                          class="input input-bordered w-20"
                        />
                        <span>-</span>
                        <input
                          type="number"
                          name={"dosage_max[#{ingredient.id}]"}
                          value={@filters.dosage_max[ingredient.id]}
                          placeholder="Max"
                          class="input input-bordered w-20"
                        />
                        <select
                          name={"dosage_unit[#{ingredient.id}]"}
                          value={@filters.dosage_unit[ingredient.id]}
                          class="select select-bordered w-20"
                        >
                          <option value="mg">mg</option>
                          <option value="g">g</option>
                          <option value="mcg">mcg</option>
                        </select>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>

          <!-- Clear Filters -->
          <div class="pt-4">
            <.button type="button" phx-click="clear_filters" variant="secondary" class="w-full">
              Clear Filters
            </.button>
          </div>
        </div>

        <!-- Products Table -->
        <div class="flex-1 overflow-x-auto">
          <table class="table table-zebra w-full">
            <thead>
              <tr>
                <th>Brand</th>
                <th>Product Name</th>
                <th>Price</th>
                <%= for ingredient <- @displayed_ingredients do %>
                  <th><%= ingredient.name %></th>
                <% end %>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody id="products" phx-update="stream">
              <tr :for={{id, product} <- @streams.products} id={id}>
                <td><%= product.brand.name %></td>
                <td><%= product.name %></td>
                <td>$<%= format_decimal(product.price) %></td>
                <%= for ingredient <- @displayed_ingredients do %>
                  <td>
                    <%= case Enum.find(product.product_ingredients, &(&1.ingredient_id == ingredient.id)) do %>
                      <% nil -> %>
                        -
                      <% pi -> %>
                        <%= format_decimal(pi.dosage_amount) %> <%= pi.dosage_unit %>
                    <% end %>
                  </td>
                <% end %>
                <td>
                  <div class="flex gap-2">
                    <.link navigate={~p"/products/#{product}"} class="btn btn-ghost btn-sm">
                      <.icon name="hero-eye" class="h-4 w-4" />
                    </.link>
                    <.link navigate={~p"/products/#{product}/edit"} class="btn btn-ghost btn-sm">
                      <.icon name="hero-pencil-square" class="h-4 w-4" />
                    </.link>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </Layouts.app>
    """
  end

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
    filters = %{
      name: params["name"] || "",
      ingredient_mode: parse_ingredient_mode_params(params["ingredient_mode"] || %{}),
      dosage_min: parse_dosage_params(params["dosage_min"] || %{}),
      dosage_max: parse_dosage_params(params["dosage_max"] || %{}),
      dosage_unit: parse_dosage_params(params["dosage_unit"] || %{})
    }
    normalized_filters = normalize_ingredient_modes(filters)
    products = filter_products(Catalog.list_products(), normalized_filters)
    
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
    Enum.reduce(Map.keys(dosage_min) ++ Map.keys(dosage_max), ingredient_mode, fn id, acc ->
      id = if is_binary(id), do: String.to_integer(id), else: id
      cond do
        Map.get(acc, id) == "exclude" -> acc
        (Map.get(dosage_min, id) not in [nil, ""]) or (Map.get(dosage_max, id) not in [nil, ""]) -> Map.put(acc, id, "include")
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
