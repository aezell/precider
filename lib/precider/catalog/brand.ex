defmodule Precider.Catalog.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  alias Precider.Catalog.Product

  schema "brands" do
    field :name, :string
    field :logo_url, :string
    field :website, :string
    field :description, :string
    field :slug, :string
    field :completed, :boolean, default: false

    has_many :products, Product

    timestamps(type: :utc_datetime)
  end

  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :logo_url, :website, :description, :slug, :completed])
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
