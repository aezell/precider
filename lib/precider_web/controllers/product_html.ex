defmodule PreciderWeb.ProductHTML do
  use PreciderWeb, :html

  import PreciderWeb.CoreComponents

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
  attr :show_ingredient_modal, :boolean, default: false
  attr :ingredient_changeset, Ecto.Changeset, required: true
  attr :ingredient_errors, :map, default: %{}

  def product_form(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)
    
    # Convert Decimal values to strings for JSON encoding
    ingredient_dosages = Map.new(assigns.ingredient_dosages, fn {k, v} -> 
      {k, Decimal.to_string(v)}
    end)
    
    assigns = assign(assigns, :ingredient_dosages, ingredient_dosages)
    
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
          <.input field={f[:weight_in_grams]} type="number" label="Weight (g)" />
          <.input field={f[:is_active]} type="checkbox" label="Active" />
        </div>

        <fieldset class="space-y-4">
          <legend class="text-lg font-medium text-base-content">Ingredients</legend>
          <.button phx-click="open_ingredient_modal" type="button" variant="secondary">
              <.icon name="hero-plus" /> Add Ingredient
            </.button>
          <div class="space-y-4" id="ingredient-rows-container">
            <!-- Dynamic ingredient rows will be rendered here by JS -->
          </div>
          <div id="ingredient-options-data" data-ingredients={Jason.encode!(@ingredients |> Enum.map(&%{id: &1.id, name: &1.name}))} style="display:none;"></div>
          <div id="ingredient-errors-data" data-ingredient-errors={Jason.encode!(@ingredient_errors)} style="display:none;"></div>
          <div id="selected-ingredients-data" 
               data-selected-ingredients={Jason.encode!(@selected_ingredient_ids)}
               data-ingredient-dosages={Jason.encode!(@ingredient_dosages)}
               data-ingredient-units={Jason.encode!(@ingredient_units)}
               style="display:none;"></div>
          <div class="flex justify-between items-center mt-4">
            <button type="button" id="add-ingredient-row" class="btn btn-outline btn-sm ml-4">+ Add another ingredient</button>
          </div>
        </fieldset>
      </div>

      <div class="flex justify-end space-x-3">
        <.button :if={@return_to} href={@return_to}>Cancel</.button>
        <.button type="submit" variant="primary">Save Product</.button>
      </div>
    </.form>

    <div id="ingredient-modal" class="hidden fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="inline-block align-bottom bg-base-100 text-base-content rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <div class="bg-base-100 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <.form :let={f} for={@ingredient_changeset} action={~p"/api/products/new/create_ingredient"} class="space-y-4" id="ingredient-form">
              <input type="hidden" name="return_to" value={@action} />
              <div>
                <label class="label">
                  <span class="label-text">Name</span>
                </label>
                <.input field={f[:name]} type="text" class="input input-bordered w-full" required />
              </div>
              <div>
                <label class="label">
                  <span class="label-text">Description</span>
                </label>
                <.input field={f[:description]} type="textarea" rows="4" class="textarea textarea-bordered w-full" />
              </div>
              <div>
                <label class="label">
                  <span class="label-text">Benefits</span>
                </label>
                <.input field={f[:benefits]} type="textarea" rows="4" class="textarea textarea-bordered w-full" />
              </div>
              <div class="mt-6 flex justify-end space-x-3">
                <button type="button" phx-click="close_ingredient_modal" class="btn btn-ghost">Cancel</button>
                <.button type="submit" class="btn btn-primary">Save Ingredient</.button>
              </div>
            </.form>
          </div>
        </div>
      </div>
    </div>

    <style>
      div.ingredient-row.ingredient-selected {
        border-color: #eab308 !important; /* Tailwind yellow-500 */
        border-width: 2px !important;
        background-color: rgba(234, 179, 8, 0.08) !important; /* Light yellow background */
        box-shadow: 0 0 0 2px #eab30833;
      }
      div.ingredient-row.ingredient-highlight {
        border-width: 2px !important;
        border-color: #22c55e !important; /* Tailwind green-500 */
      }
    </style>
    """
  end
end
