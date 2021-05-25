defmodule Pollution.Repo.Migrations.CreateMeasurement do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :station_id, references(:stations), null: false
      add :date, :timestamp, null: false
      add :type, :string, null: false
      add :value, :float, null: false
    end

  end

end
