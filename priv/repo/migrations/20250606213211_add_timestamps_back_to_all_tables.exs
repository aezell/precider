defmodule Precider.Repo.Migrations.AddTimestampsBackToAllTables do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :inserted_at, :utc_datetime
      add :updated_at, :utc_datetime
    end

    alter table(:brands) do
      add :inserted_at, :utc_datetime
      add :updated_at, :utc_datetime
    end

    alter table(:ingredients) do
      add :inserted_at, :utc_datetime
      add :updated_at, :utc_datetime
    end

    alter table(:product_ingredients) do
      add :inserted_at, :utc_datetime
      add :updated_at, :utc_datetime
    end
  end
end
