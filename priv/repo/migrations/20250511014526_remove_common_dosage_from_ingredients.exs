defmodule Precider.Repo.Migrations.RemoveCommonDosageFromIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      remove :common_dosage
    end
  end
end
