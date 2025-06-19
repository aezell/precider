defmodule Precider.Repo.Migrations.CategorizeRemainingIngredients do
  use Ecto.Migration

  def up do
    # ENERGY INGREDIENTS (Stimulants, Energy, Fat Burners)
    execute """
    UPDATE ingredients SET category = 'energy' WHERE name IN (
      'N-Isopropylnorsynephrine',
      'N-Phenethyl Dimethylamine Citrate',
      'Paradoxine',
      'Paraxanthine',
      'Phenylethylamine HCI',
      'PurCaf',
      'Raspberry Ketone',
      'Rauwolfa Vomitoria',
      'SaniEnergy Nu',
      'Synephrine',
      'Theacrine',
      'Theobromine',
      'VitaShure Caffeine SR',
      'Xternergy',
      'Yerba Mate Extract',
      'Yohimbine',
      'zumDR',
      'zumXR',
      'Zynamite'
    );
    """

    # FOCUS INGREDIENTS (Cognitive enhancers, Nootropics)
    execute """
    UPDATE ingredients SET category = 'focus' WHERE name IN (
      'KSM-66',
      'Mucuna Pruriens',
      'Neurofactor',
      'NeuroRush',
      'NooLVL',
      'Pregnenolone',
      'Rhodiola Rosea',
      'Synaptrix',
      'Uridine 5''-Monophosphate Disodium Salt'
    );
    """

    # ENDURANCE INGREDIENTS (Performance, Recovery, Antioxidants)
    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'Catuaba',
      'Longjack',
      'Maca Root Powder',
      'N-Acetyl Cysteine',
      'Oligonol',
      'Peak02',
      'PEAK ATP',
      'Phyt02',
      'Pine Bark Extract',
      'PureWay-C',
      'Rutaecarpine',
      'Safed Musli',
      'Senactiv',
      'Setria L-Glutathione',
      'Taurine',
      'Trimethylglycine'
    );
    """

    # PUMP INGREDIENTS (Vasodilators, Nitric Oxide, Blood Flow)
    execute """
    UPDATE ingredients SET category = 'pump' WHERE name IN (
      'N03-T',
      'Nitro Rocket',
      'Nitrosigine',
      'Norvaline',
      'PeptiPump',
      'S7',
      'VasoDrive AP',
      'Watermelon Juice Powder'
    );
    """

    # ABSORPTION/BIOAVAILABILITY ENHANCERS (Support category - could be separate)
    # For now, categorizing as endurance since they support overall supplement effectiveness
    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'ActiGin',
      'AstraGin',
      'BioPerine',
      'Naringin Extract'
    );
    """

    # HEALTH/GENERAL WELLNESS (Hard to categorize, leaving as endurance for general support)
    execute """
    UPDATE ingredients SET category = 'endurance' WHERE name IN (
      'Chromium Picolinate',
      'Collagen',
      'Dandelion Extract',
      'Horny Goat Weed',
      'Hyaluronic Acid',
      'N-Palmitoylethanolamide',
      'Organic Kelp',
      'Potassium Dodecanedioate',
      'Sodium Dodecanedioate'
    );
    """
  end

  def down do
    execute """
    UPDATE ingredients SET category = NULL WHERE name IN (
      'ActiGin', 'AstraGin', 'BioPerine', 'Catuaba', 'Chromium Picolinate',
      'Collagen', 'Dandelion Extract', 'Horny Goat Weed', 'Hyaluronic Acid',
      'KSM-66', 'Longjack', 'Maca Root Powder', 'Mucuna Pruriens', 'N03-T',
      'N-Acetyl Cysteine', 'Naringin Extract', 'Neurofactor', 'NeuroRush',
      'N-Isopropylnorsynephrine', 'Nitro Rocket', 'Nitrosigine', 'NooLVL',
      'Norvaline', 'N-Palmitoylethanolamide', 'N-Phenethyl Dimethylamine Citrate',
      'Oligonol', 'Organic Kelp', 'Paradoxine', 'Paraxanthine', 'Peak02',
      'PEAK ATP', 'PeptiPump', 'Phenylethylamine HCI', 'Phyt02',
      'Pine Bark Extract', 'Potassium Dodecanedioate', 'Pregnenolone',
      'PurCaf', 'PureWay-C', 'Raspberry Ketone', 'Rauwolfa Vomitoria',
      'Rhodiola Rosea', 'Rutaecarpine', 'S7', 'Safed Musli', 'SaniEnergy Nu',
      'Senactiv', 'Setria L-Glutathione', 'Sodium Dodecanedioate', 'Synaptrix',
      'Synephrine', 'Taurine', 'Theacrine', 'Theobromine',
      'Trimethylglycine', 'Uridine 5''-Monophosphate Disodium Salt',
      'VasoDrive AP', 'VitaShure Caffeine SR', 'Watermelon Juice Powder',
      'Xternergy', 'Yerba Mate Extract', 'Yohimbine', 'zumDR', 'zumXR', 'Zynamite'
    );
    """
  end
end
