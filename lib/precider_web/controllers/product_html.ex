defmodule PreciderWeb.ProductHTML do
  use PreciderWeb, :html

  embed_templates "product_html/*"

  @doc """
  Renders a product form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :brand_options, :list, required: true
  attr :ingredients, :list, required: true
  attr :selected_ingredient_ids, :list, required: true
  attr :ingredient_dosages, :map, required: true
  attr :ingredient_units, :map, required: true

  def product_form(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} action={@action} class="space-y-8">
      <div class="space-y-4">
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <.input field={f[:name]} type="text" label="Name" required />
          <.input field={f[:brand_id]} type="select" label="Brand" options={@brand_options} required />
        </div>

        <.input field={f[:description]} type="textarea" label="Description" rows={4} />

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <.input field={f[:url]} type="text" label="Product URL" />
          <.input field={f[:image_url]} type="text" label="Image URL" />
        </div>

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
          <.input field={f[:price]} type="number" step="0.01" label="Price" required />
          <.input field={f[:serving_size]} type="text" label="Serving Size" />
          <.input field={f[:servings_per_container]} type="number" label="Servings Per Container" />
        </div>

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <.input field={f[:flavor]} type="text" label="Flavor" />
          <.input field={f[:weight_in_grams]} type="number" label="Weight (g)" />
        </div>

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <.input field={f[:release_date]} type="date" label="Release Date" />
          <.input field={f[:is_active]} type="checkbox" label="Active" />
        </div>
      </div>

      <div class="space-y-4">
        <fieldset class="space-y-4">
          <legend class="text-lg font-medium leading-6 text-white-900">Ingredients</legend>
          <div class="space-y-4">
            <%= for ingredient <- @ingredients do %>
              <div class="flex items-center space-x-3 p-4 bg-base-100 rounded-lg border border-base-300">
                <input
                  type="checkbox"
                  name={"product[ingredient_ids][]"}
                  value={ingredient.id}
                  checked={ingredient.id in (@selected_ingredient_ids || [])}
                  class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded mr-2"
                />
                <label class="text-sm font-medium text-base-content mr-4 min-w-[120px]">
                  <%= ingredient.name %>
                </label>
                <div class="flex items-center space-x-2 flex-1">
                  <label class="block text-xs font-medium text-base-content">Dosage</label>
                  <input
                    type="number"
                    step="any"
                    name={"product[ingredient_dosages][#{ingredient.id}]"}
                    value={get_in(@ingredient_dosages, [ingredient.id]) || ""}
                    class="ml-1 w-24 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100 placeholder:text-base-content/70"
                    placeholder="Amount"
                  />
                  <select
                    name={"product[ingredient_units][#{ingredient.id}]"}
                    class="w-16 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100"
                  >
                    <option value="mg" selected={get_in(@ingredient_units, [ingredient.id]) in [nil, "", "mg"]}>mg</option>
                    <option value="g" selected={get_in(@ingredient_units, [ingredient.id]) == "g"}>g</option>
                    <option value="mcg" selected={get_in(@ingredient_units, [ingredient.id]) == "mcg"}>mcg</option>
                  </select>
                </div>
              </div>
            <% end %>
          </div>
        </fieldset>
      </div>

      <div class="flex justify-end space-x-3">
        <.button :if={@return_to} href={@return_to}>Cancel</.button>
        <.button type="submit" variant="primary">Save Product</.button>
      </div>
    </.form>
    """
  end
end
