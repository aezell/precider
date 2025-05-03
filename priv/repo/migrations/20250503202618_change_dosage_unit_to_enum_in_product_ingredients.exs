defmodule Precider.Repo.Migrations.ChangeDosageUnitToEnumInProductIngredients do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TYPE dosage_unit_enum AS ENUM ('mg', 'g', 'mcg');
    """)

    execute("""
    ALTER TABLE product_ingredients
    ALTER COLUMN dosage_unit TYPE dosage_unit_enum USING dosage_unit::text::dosage_unit_enum;
    """)
  end

  def down do
    execute("""
    ALTER TABLE product_ingredients
    ALTER COLUMN dosage_unit TYPE varchar;
    """)
    execute("DROP TYPE dosage_unit_enum;")
  end
end
