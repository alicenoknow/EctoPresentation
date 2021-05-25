defmodule Pollution.Measurement do
  use Ecto.Schema

  schema "measurements" do
    field :date, :naive_datetime
    field :type, :string
    field :value, :float
    belongs_to :station, Pollution.Station
  end

  def changeset(measurement, params \\ %{}) do
    measurement
    |> Ecto.Changeset.cast(params, [:station_id, :date, :type, :value])
    |> Ecto.Changeset.validate_required([:station_id, :date, :type, :value])
  end

end