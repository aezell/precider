defmodule Precider.Catalog.ProductIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Precider.Catalog.{Product, Ingredient}

  schema "product_ingredients" do
    field :dosage_amount, :integer
    field :dosage_unit, Ecto.Enum, values: [:mg, :g, :mcg]
    
    belongs_to :product, Product
    belongs_to :ingredient, Ingredient

    timestamps()
  end

  def changeset(product_ingredient, attrs) do
    product_ingredient
    |> cast(attrs, [:dosage_amount, :dosage_unit, :product_id, :ingredient_id])
    |> validate_required([:dosage_amount, :dosage_unit, :ingredient_id])
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:ingredient_id)
    |> unique_constraint([:product_id, :ingredient_id], 
        name: :product_ingredient_unique_index, 
        message: "Ingredient already added to this product")
  end
end
