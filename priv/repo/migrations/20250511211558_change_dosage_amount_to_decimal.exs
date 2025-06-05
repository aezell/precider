defmodule Precider.Repo.Migrations.ChangeDosageAmountToDecimal do
  use Ecto.Migration

  def change do
    alter table(:product_ingredients) do
      modify :dosage_amount, :decimal, precision: 10, scale: 2
    end
  end
end
