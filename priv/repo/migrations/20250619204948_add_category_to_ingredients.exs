defmodule Precider.Repo.Migrations.AddCategoryToIngredients do
  use Ecto.Migration

  def up do
    # Add the category column
    alter table(:ingredients) do
      add :category, :string
    end

    # Update ingredients with categories
    execute """
    UPDATE ingredients SET category = 'energy' WHERE name IN (
      'Caffeine Anhydrous',
      'Caffeine Citrate', 
      'Caffeine Natural',
      'Di-Caffeine Malate',
      'Guarana Extract',
      'Green Tea Leaf Extract',
      'InnovaTea',
      'AmaTea',
      '2-Aminoisoheptane',
      'Beta Phenylethylamine HCL',
      'Bitter Orange Extract',
      'Citrus aurantium Extract',
      'Eria Jarensis',
      'Halostachine',
      'Methylliberine',
      'Dendrobium Stem Extract',
      'Evodiamine',
      'Hemerocallis Fulva',
      'Juglandis',
      'Juniperus communis',
      'goMCT',
      'MitoBurn',
      'CapsiAtra',
      'Cayenne',
      'Caloriburn GP',
      'African Wild Mango Seed',
      'Ashwagandha',
      'Grapefruit Extract',
      'Cocoabuterol',
      'InnoSlim'
    );
    """

    execute """
    UPDATE ingredients SET category = 'focus' WHERE name IN (
      'Alpha GPC',
      'Citicoline',
      'Choline Bitartrate',
      'L-Tyrosine',
      'L-Theanine',
      'DMAE',
      'Huperzine A',
      'Lion''s Mane',
      'Ginkgo Biloba',
      'Kanna',
      'Lotus Extract',
      'Cognatiq',
      'GABA',
      'DL-Phenylalanine',
      'Inositol Arginine Silicate',
      'Eria Jarensis'
    );
    """

    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'Beta Alanine',
      'L-Carnitine Fumarate',
      'L-Carnitine L-Tartrate',
      'Acetyl-L-Carnitine',
      'Cluster Dextrin',
      'ElevATP',
      'D-Aspartic Acid',
      'L-Leucine',
      'L-Isoleucine',
      'L-Valine',
      'L-Glycine',
      'Beet Root Extract',
      'Epicatechin',
      'Grape Seed Extract',
      'Dan Shen',
      'Indian Gooseberry Fruit Extract',
      'Deer Antler Velvet Extract',
      'Metabolyte',
      'Aquamin',
      'Albion Potassium Glycinate',
      'Calci-K'
    );
    """

    execute """
    UPDATE ingredients SET category = 'pump' WHERE name IN (
      'L-Citrulline',
      'CitraPEAK',
      'Citrafuze',
      'L-Arginine',
      'Arginine Nitrate',
      'Agmatine Sulfate',
      'Betaine Nitrate',
      'L-Norvaline',
      'L-Ornithine Hydrochloride',
      'Glycerol Monostearate',
      'Glycerpump',
      'Glycersize',
      'HydroMax',
      'HydroPrime',
      'EndoFlo',
      'FitNox',
      'GBB (Gamma Butyrobetaine Ethyl Ester)',
      'L-Taurine'
    );
    """

    # Note: Some ingredients could fit multiple categories or don't clearly fit one category
    # These will remain NULL and can be manually categorized later if needed:
    # ActiGin, AstraGin, BioPerine, Betaine Anhydrous, Creapure, Creatine, 
    # Dandelion Extract, Catuaba, Chromium Picolinate, Collagen, Horny Goat Weed,
    # Hyaluronic Acid, Kre-Alkalyn, KSM-66, Longjack, Maca Root Powder, etc.
  end

  def down do
    alter table(:ingredients) do
      remove :category
    end
  end
end
