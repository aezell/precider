defmodule Precider.Repo.Migrations.CategorizeFatLossIngredients do
  use Ecto.Migration

  def up do
    # FAT LOSS / THERMOGENIC INGREDIENTS
    # These ingredients are specifically used for fat burning, thermogenesis, and weight management
    execute """
    UPDATE ingredients SET category = 'fat_loss' WHERE name IN (
      'Acetyl-L-Carnitine',
      'African Wild Mango Seed',
      'Bitter Orange Extract',
      'Caloriburn GP',
      'CapsiAtra',
      'Cayenne',
      'Citrus aurantium Extract',
      'Cocoabuterol',
      'Evodiamine',
      'GBB (Gamma Butyrobetaine Ethyl Ester)',
      'Grapefruit Extract',
      'Green Tea Leaf Extract',
      'Guarana Extract',
      'Halostachine',
      'InnoSlim',
      'L-Carnitine Fumarate',
      'L-Carnitine L-Tartrate',
      'MitoBurn'
    );
    """
  end

  def down do
    # Revert fat loss ingredients back to their original categories
    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'Acetyl-L-Carnitine',
      'L-Carnitine Fumarate',
      'L-Carnitine L-Tartrate'
    );
    """

    execute """
    UPDATE ingredients SET category = 'energy' WHERE name IN (
      'African Wild Mango Seed',
      'Bitter Orange Extract',
      'Caloriburn GP',
      'CapsiAtra',
      'Cayenne',
      'Citrus aurantium Extract',
      'Cocoabuterol',
      'Evodiamine',
      'Grapefruit Extract',
      'Green Tea Leaf Extract',
      'Guarana Extract',
      'Halostachine',
      'InnoSlim',
      'MitoBurn'
    );
    """

    execute """
    UPDATE ingredients SET category = 'pump' WHERE name = 'GBB (Gamma Butyrobetaine Ethyl Ester)';
    """
  end
end
