defmodule PreciderWeb.ProductIngredientHTML do
  use PreciderWeb, :html

  embed_templates "product_ingredient_html/*"

  @doc """
  Renders a product_ingredient form.

  The form is defined in the template at
  product_ingredient_html/product_ingredient_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def product_ingredient_form(assigns)
end
