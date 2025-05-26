defmodule Precider.Repo.Migrations.ChangeDosageUnitToEnumInProductIngredients do
  use Ecto.Migration

  def up do
    # In SQLite, we use a string for enums and enforce allowed values in application logic
    # No changes needed if dosage_unit is already a string
    # If you want to enforce allowed values, use a CHECK constraint or handle in Ecto changeset
  end

  def down do
    # No-op for SQLite
  end
end
