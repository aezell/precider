defmodule Precider.Catalog.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Precider.Catalog.ProductIngredient

  @derive {Jason.Encoder, only: [:id, :name, :description, :benefits, :slug]}
  schema "ingredients" do
    field :name, :string
    field :description, :string
    field :benefits, :string
    field :slug, :string

    has_many :product_ingredients, ProductIngredient
    has_many :products, through: [:product_ingredients, :product]

    timestamps(type: :utc_datetime)
  end

  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :description, :benefits, :slug])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> put_slug()
  end
  
  defp put_slug(%Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset) do
    slug = name |> String.downcase() |> String.replace(~r/[^a-z0-9]+/, "-") |> String.trim("-")
    put_change(changeset, :slug, slug)
  end
  
  defp put_slug(changeset), do: changeset
end
