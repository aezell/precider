defmodule Precider.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :string, null: false
      add :description, :text
      add :common_dosage, :string
      add :benefits, :text
      add :slug, :string

      timestamps()
    end

    create unique_index(:ingredients, [:name])
    create unique_index(:ingredients, [:slug])
  end
end
