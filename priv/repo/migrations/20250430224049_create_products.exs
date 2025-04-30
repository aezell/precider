defmodule Precider.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :url, :string
      add :image_url, :string
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :serving_size, :string
      add :servings_per_container, :integer
      add :flavor, :string
      add :weight_in_grams, :integer
      add :release_date, :date
      add :is_active, :boolean, default: true, null: false
      add :slug, :string
      add :search_vector, :tsvector
      add :brand_id, references(:brands, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:products, [:brand_id])
    create unique_index(:products, [:name, :brand_id])
    create unique_index(:products, [:slug])
  end
end
