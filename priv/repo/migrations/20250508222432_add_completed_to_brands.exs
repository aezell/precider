defmodule Precider.Repo.Migrations.AddCompletedToBrands do
  use Ecto.Migration

  def change do
    alter table(:brands) do
      add :completed, :boolean, default: false, null: false
    end
  end
end
