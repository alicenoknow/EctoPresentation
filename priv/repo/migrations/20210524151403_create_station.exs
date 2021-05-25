defmodule Pollution.Repo.Migrations.CreateStation do
  use Ecto.Migration

  def change do
    create table(:stations) do
      add :name, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false

    end

    create unique_index(:stations, [:latitude, :longitude])
    create unique_index(:stations, :name)
end

end
