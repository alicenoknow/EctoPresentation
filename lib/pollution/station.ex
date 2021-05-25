defmodule Pollution.Station do
  use Ecto.Schema

  schema "stations" do
    field :name, :string
    field :latitude, :float
    field :longitude, :float
    has_many :measurements, Pollution.Measurement
  end

  def changeset(station, params \\ %{}) do
    station
    |> Ecto.Changeset.cast(params, [:name, :latitude, :longitude])
    |> Ecto.Changeset.validate_required([:name, :latitude, :longitude])
    |> validate_float_range(:latitude, -90.0, 90.0)
    |> validate_float_range(:longitude, -180.0, 180.0)
    |> Ecto.Changeset.unique_constraint(:name)
  end

  def validate_float_range(changeset, value, lower, higher) do
    Ecto.Changeset.validate_change(changeset, value, fn _, value ->
      case value >= lower and value <= higher do
        true -> []
        false -> [{value, "Invalid range of float number"}]
      end
    end)
  end

end