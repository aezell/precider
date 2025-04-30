defmodule PreciderWeb.IngredientHTML do
  use PreciderWeb, :html

  embed_templates "ingredient_html/*"

  @doc """
  Renders a ingredient form.

  The form is defined in the template at
  ingredient_html/ingredient_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def ingredient_form(assigns)
end
