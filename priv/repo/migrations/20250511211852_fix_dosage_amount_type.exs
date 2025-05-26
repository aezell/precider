defmodule Precider.Repo.Migrations.FixDosageAmountType do
  use Ecto.Migration

  def up do
    # Create a new table with the desired schema
    create table(:product_ingredients_new) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :ingredient_id, references(:ingredients, on_delete: :delete_all), null: false
      add :dosage_amount, :decimal, precision: 10, scale: 2
      add :dosage_unit, :string
      timestamps()
    end

    # Copy data from the old table to the new one
    execute """
    INSERT INTO product_ingredients_new (id, product_id, ingredient_id, dosage_amount, dosage_unit, inserted_at, updated_at)
    SELECT id, product_id, ingredient_id, CAST(dosage_amount AS decimal), dosage_unit, inserted_at, updated_at
    FROM product_ingredients
    """

    # Drop the old table
    drop table(:product_ingredients)

    # Rename the new table to the original name
    execute "ALTER TABLE product_ingredients_new RENAME TO product_ingredients"

    # Recreate the index
    create index(:product_ingredients, [:product_id])
    create index(:product_ingredients, [:ingredient_id])
  end

  def down do
    # Create a new table with the integer column
    create table(:product_ingredients_new) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :ingredient_id, references(:ingredients, on_delete: :delete_all), null: false
      add :dosage_amount, :integer
      add :dosage_unit, :string
      timestamps()
    end

    # Copy data from the old table to the new one
    execute """
    INSERT INTO product_ingredients_new (id, product_id, ingredient_id, dosage_amount, dosage_unit, inserted_at, updated_at)
    SELECT id, product_id, ingredient_id, CAST(dosage_amount AS integer), dosage_unit, inserted_at, updated_at
    FROM product_ingredients
    """

    # Drop the old table
    drop table(:product_ingredients)

    # Rename the new table to the original name
    execute "ALTER TABLE product_ingredients_new RENAME TO product_ingredients"

    # Recreate the index
    create index(:product_ingredients, [:product_id])
    create index(:product_ingredients, [:ingredient_id])
  end
end
