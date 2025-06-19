defmodule Precider.Repo.Migrations.AddStrengthCategoryIngredients do
  use Ecto.Migration

  def up do
    execute """
    UPDATE ingredients SET category = 'strength' WHERE name IN (
      'Creatine',
      'Creapure',
      'Kre-Alkalyn',
      'Betaine Anhydrous'
    );
    """
  end

  def down do
    execute """
    UPDATE ingredients SET category = NULL WHERE name IN (
      'Creatine',
      'Creapure', 
      'Kre-Alkalyn',
      'Betaine Anhydrous'
    );
    """
  end
end
