defmodule Precider.Repo.Migrations.FixDosageAmountType do
  use Ecto.Migration

  def up do
    # First, create a temporary column
    alter table(:product_ingredients) do
      add :dosage_amount_decimal, :decimal, precision: 10, scale: 2
    end

    # Copy data from the old column to the new one
    execute """
    UPDATE product_ingredients 
    SET dosage_amount_decimal = CAST(dosage_amount AS decimal)
    """

    # Drop the old column
    alter table(:product_ingredients) do
      remove :dosage_amount
    end

    # Rename the new column to the original name
    rename table(:product_ingredients), :dosage_amount_decimal, to: :dosage_amount
  end

  def down do
    # First, create a temporary column
    alter table(:product_ingredients) do
      add :dosage_amount_int, :integer
    end

    # Copy data from the decimal column to the integer column
    execute """
    UPDATE product_ingredients 
    SET dosage_amount_int = CAST(dosage_amount AS integer)
    """

    # Drop the decimal column
    alter table(:product_ingredients) do
      remove :dosage_amount
    end

    # Rename the integer column to the original name
    rename table(:product_ingredients), :dosage_amount_int, to: :dosage_amount
  end
end
