defmodule Precider.Repo.Migrations.AddAdditionalFatLossIngredients do
  use Ecto.Migration

  def up do
    # Additional FAT LOSS / THERMOGENIC INGREDIENTS
    # These are additional ingredients that were missed in the first fat loss migration
    execute """
    UPDATE ingredients SET category = 'fat_loss' WHERE name IN (
      '2-Aminoisoheptane',
      'Chromium Picolinate',
      'Dandelion Extract',
      'Paradoxine',
      'Raspberry Ketone',
      'Rauwolfa Vomitoria',
      'Synephrine',
      'Yohimbine'
    );
    """
  end

  def down do
    # Revert additional fat loss ingredients back to their original categories
    execute """
    UPDATE ingredients SET category = 'energy' WHERE name IN (
      '2-Aminoisoheptane',
      'Paradoxine',
      'Raspberry Ketone',
      'Rauwolfa Vomitoria',
      'Synephrine',
      'Yohimbine'
    );
    """

    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'Chromium Picolinate',
      'Dandelion Extract'
    );
    """
  end
end
