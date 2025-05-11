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
      </div>

      <div class="space-y-4">
        <fieldset class="space-y-4">
          <div class="flex items-center justify-between">
            <legend class="text-lg font-medium leading-6 text-white-900">Ingredients</legend>
            <button
              type="button"
              phx-click="open_ingredient_modal"
              class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <.icon name="hero-plus" class="h-4 w-4 mr-1" />
              Add Ingredient
            </button>
          </div>
          <div class="space-y-4" id="ingredients-list">
            <%= for ingredient <- @ingredients do %>
              <div class="flex items-center space-x-3 p-4 bg-base-100 rounded-lg border border-base-300 ingredient-row">
                <input
                  type="checkbox"
                  name={"product[ingredient_ids][]"}
                  value={ingredient.id}
                  checked={ingredient.id in (@selected_ingredient_ids || [])}
                  class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded mr-2"
                />
                <label class="text-sm font-medium text-base-content w-[300px] truncate" title={ingredient.name}>
                  <%= ingredient.name %>
                </label>
                <div class="flex items-center space-x-2 flex-1">
                  <label class="block text-xs font-medium text-base-content">Dosage</label>
                  <div class="flex flex-col">
                    <input
                      type="number"
                      step="any"
                      name={"product[ingredient_dosages][#{ingredient.id}]"}
                      value={get_in(@ingredient_dosages, [ingredient.id]) || ""}
                      class={"ml-1 w-24 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100 placeholder:text-base-content/70 #{if Map.has_key?(@ingredient_errors, ingredient.id), do: "border-red-500", else: ""}"}
                      placeholder="Amount"
                    />
                    <%= if errors = get_in(@ingredient_errors, [ingredient.id, :dosage_amount]) do %>
                      <span class="text-xs text-red-500 mt-1"><%= elem(errors, 0) %></span>
                    <% end %>
                  </div>
                  <div class="flex flex-col">
                    <select
                      name={"product[ingredient_units][#{ingredient.id}]"}
                      class={"w-16 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100 #{if Map.has_key?(@ingredient_errors, ingredient.id), do: "border-red-500", else: ""}"}
                    >
                      <option value="mg" selected={get_in(@ingredient_units, [ingredient.id]) in [nil, "", "mg"]}>mg</option>
                      <option value="g" selected={get_in(@ingredient_units, [ingredient.id]) == "g"}>g</option>
                      <option value="mcg" selected={get_in(@ingredient_units, [ingredient.id]) == "mcg"}>mcg</option>
                    </select>
                    <%= if errors = get_in(@ingredient_errors, [ingredient.id, :dosage_unit]) do %>
                      <span class="text-xs text-red-500 mt-1"><%= elem(errors, 0) %></span>
                    <% end %>
                  </div>
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

    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const modal = document.getElementById('ingredient-modal');
        const openButton = document.querySelector('[phx-click="open_ingredient_modal"]');
        const closeButton = document.querySelector('[phx-click="close_ingredient_modal"]');
        const ingredientForm = document.getElementById('ingredient-form');
        const ingredientsList = document.getElementById('ingredients-list');

        // Add checkbox change handlers
        function setupCheckboxHandlers() {
          const checkboxes = document.querySelectorAll('input[type="checkbox"][name="product[ingredient_ids][]"]');
          checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
              const ingredientRow = this.closest('.ingredient-row');
              if (this.checked) {
                ingredientRow.classList.add('ingredient-selected');
              } else {
                ingredientRow.classList.remove('ingredient-selected');
              }
            });
            // Set initial state
            if (checkbox.checked) {
              checkbox.closest('.ingredient-row').classList.add('ingredient-selected');
            }
          });
        }

        openButton.addEventListener('click', function() {
          modal.classList.remove('hidden');
        });

        closeButton.addEventListener('click', function() {
          modal.classList.add('hidden');
        });

        ingredientForm.addEventListener('submit', async function(e) {
          e.preventDefault();
          
          const formData = new FormData(ingredientForm);
          
          try {
            const response = await fetch(ingredientForm.action, {
              method: 'POST',
              body: formData,
              headers: {
                'Accept': 'application/json'
              }
            });

            if (response.ok) {
              const data = await response.json();
              
              // Close the modal
              modal.classList.add('hidden');
              
              // Create new ingredient element
              const ingredientElement = document.createElement('div');
              ingredientElement.className = 'flex items-center space-x-3 p-4 bg-base-100 rounded-lg border border-green-500 ingredient-highlight ingredient-row';
              ingredientElement.innerHTML = `
                <input
                  type="checkbox"
                  name="product[ingredient_ids][]"
                  value="${data.ingredient.id}"
                  class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded mr-2"
                />
                <label class="text-sm font-medium text-base-content w-[300px] truncate" title="${data.ingredient.name}">
                  ${data.ingredient.name}
                </label>
                <div class="flex items-center space-x-2 flex-1">
                  <label class="block text-xs font-medium text-base-content">Dosage</label>
                  <input
                    type="number"
                    step="any"
                    name="product[ingredient_dosages][${data.ingredient.id}]"
                    class="ml-1 w-24 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100 placeholder:text-base-content/70"
                    placeholder="Amount"
                  />
                  <select
                    name="product[ingredient_units][${data.ingredient.id}]"
                    class="w-16 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100"
                  >
                    <option value="mg" selected>mg</option>
                    <option value="g">g</option>
                    <option value="mcg">mcg</option>
                  </select>
                </div>
              `;

              // Insert alphabetically
              const ingredientRows = Array.from(ingredientsList.children);
              const newName = data.ingredient.name.toLowerCase();
              let inserted = false;
              for (let i = 0; i < ingredientRows.length; i++) {
                const label = ingredientRows[i].querySelector('label');
                if (label && label.textContent.trim().toLowerCase() > newName) {
                  ingredientsList.insertBefore(ingredientElement, ingredientRows[i]);
                  inserted = true;
                  break;
                }
              }
              if (!inserted) {
                ingredientsList.appendChild(ingredientElement);
              }

              // Setup checkbox handler for the new ingredient
              setupCheckboxHandlers();
            } else {
              // Handle error
              const data = await response.json();
              alert('Error creating ingredient: ' + (data.errors || 'Unknown error'));
            }
          } catch (error) {
            console.error('Error:', error);
            alert('Error creating ingredient. Please try again.');
          }
        });

        // Initial setup of checkbox handlers
        setupCheckboxHandlers();
      });
    </script>
    <style>
      .ingredient-highlight {
        border-width: 2px !important;
        border-color: #22c55e !important; /* Tailwind green-500 */
      }
      .ingredient-selected {
        border-color: #eab308 !important; /* Tailwind yellow-500 */
        border-width: 2px !important;
      }
    </style>
    """
  end
end
