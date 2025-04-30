defmodule Precider.Repo.Migrations.CreateProductIngredients do
  use Ecto.Migration

  def change do
    create table(:product_ingredients) do
      add :dosage_amount, :decimal, precision: 10, scale: 2, null: false
      add :dosage_unit, :string, null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :ingredient_id, references(:ingredients, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:product_ingredients, [:product_id])
    create index(:product_ingredients, [:ingredient_id])
    create unique_index(:product_ingredients, [:product_id, :ingredient_id], 
                        name: :product_ingredient_unique_index)
    
    # Create indexes for dosage filtering and sorting
    create index(:product_ingredients, [:ingredient_id, :dosage_amount])
  end
end
