defmodule Precider.Repo.Migrations.RemoveReleaseDateAndFlavorFromProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :release_date
      remove :flavor
    end
  end
end
