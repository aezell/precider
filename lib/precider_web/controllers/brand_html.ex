defmodule PreciderWeb.BrandHTML do
  use PreciderWeb, :html

  embed_templates "brand_html/*"

  @doc """
  Renders a brand form.

  The form is defined in the template at
  brand_html/brand_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def brand_form(assigns)
end
