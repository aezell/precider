defmodule Precider.Repo.Migrations.ChangeDosageAmountToIntegerInProductIngredients do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE product_ingredients
    ALTER COLUMN dosage_amount TYPE integer USING ROUND(dosage_amount);
    """)
  end

  def down do
    execute("""
    ALTER TABLE product_ingredients
    ALTER COLUMN dosage_amount TYPE numeric(10,2) USING dosage_amount::numeric(10,2);
    """)
  end
end
