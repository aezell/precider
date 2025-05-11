defmodule Precider.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Precider.Catalog.{Brand, ProductIngredient}

  schema "products" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :image_url, :string
    field :price, :decimal
    field :serving_size, :string
    field :servings_per_container, :integer
    field :weight_in_grams, :integer
    field :is_active, :boolean, default: true
    field :slug, :string

    belongs_to :brand, Brand
    has_many :product_ingredients, ProductIngredient, on_replace: :delete
    has_many :ingredients, through: [:product_ingredients, :ingredient]

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :url, :image_url, :price, :serving_size, 
                    :servings_per_container, :weight_in_grams, 
                    :is_active, :brand_id, :slug])
    |> validate_required([:name, :price, :brand_id])
    |> foreign_key_constraint(:brand_id)
    |> unique_constraint([:name, :brand_id])
    |> unique_constraint(:slug)
    |> cast_assoc(:product_ingredients, with: &ProductIngredient.changeset/2)
    |> put_slug()
  end

  defp put_slug(%Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset) do
    slug = name |> String.downcase() |> String.replace(~r/[^a-z0-9]+/, "-") |> String.trim("-")
    put_change(changeset, :slug, slug)
  end
  
  defp put_slug(changeset), do: changeset
end
