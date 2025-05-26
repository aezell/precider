defmodule Precider.Repo.Migrations.ChangeDosageAmountToIntegerInProductIngredients do
  use Ecto.Migration

  def up do
    # Drop index before removing the column
    drop index(:product_ingredients, [:ingredient_id, :dosage_amount])

    alter table(:product_ingredients) do
      add :dosage_amount_int, :integer
    end

    execute "UPDATE product_ingredients SET dosage_amount_int = ROUND(dosage_amount)"

    alter table(:product_ingredients) do
      remove :dosage_amount
    end

    rename table(:product_ingredients), :dosage_amount_int, to: :dosage_amount

    # Recreate the index with the new column
    create index(:product_ingredients, [:ingredient_id, :dosage_amount])
  end

  def down do
    drop index(:product_ingredients, [:ingredient_id, :dosage_amount])

    alter table(:product_ingredients) do
      add :dosage_amount_decimal, :decimal, precision: 10, scale: 2
    end

    execute "UPDATE product_ingredients SET dosage_amount_decimal = dosage_amount"

    alter table(:product_ingredients) do
      remove :dosage_amount
    end

    rename table(:product_ingredients), :dosage_amount_decimal, to: :dosage_amount

    create index(:product_ingredients, [:ingredient_id, :dosage_amount])
  end
end
