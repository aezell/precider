defmodule Precider.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string, null: false
      add :logo_url, :string
      add :website, :string
      add :description, :text
      add :slug, :string

      timestamps()
    end

    create unique_index(:brands, [:name])
    create unique_index(:brands, [:slug])
  end
end
