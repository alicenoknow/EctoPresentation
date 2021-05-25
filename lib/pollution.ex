defmodule Pollution do


  def addStation(name, location) do
    changeset = Pollution.Station.changeset(%Pollution.Station{},
                                            %{name: name,
                                              latitude: elem(location, 0),
                                              longitude: elem(location, 1)})
    Pollution.Repo.insert!(changeset)
  end


  def addValue(location, datetime, type, pollutionLevel) do
    import Ecto.Query, only: [from: 2]
    query = from s in "stations",
                 where: s.latitude == ^elem(location, 0) and s.longitude == ^elem(location, 1),
                 select: s.id
    [id] = Pollution.Repo.all(query)
    changeset = Pollution.Measurement.changeset(%Pollution.Measurement{},
                                                %{station_id: id,
                                                  date: datetime,
                                                  type: type,
                                                  value: pollutionLevel})
    Pollution.Repo.insert!(changeset)
  end


  def queryAllStations() do
    import Ecto.Query, only: [from: 2]
    query = from s in "stations",
                 select: {s.name, s.latitude, s.longitude}

    Pollution.Repo.all(query)
  end


  def queryAllMeasurements() do
    import Ecto.Query, only: [from: 2]
    query = from m in "measurements",
                join: s in "stations", on: [id: m.station_id],
                select: {s.name, m.type, m.date, m.value}

    Pollution.Repo.all(query)
  end


  def getStationMean(station, type) do
    import Ecto.Query, only: [from: 2]

    query = from m in "measurements",
                join: s in "stations", on: [id: m.station_id],
                where: m.type == ^type and s.name == ^station,
                select: avg(m.value)

    Pollution.Repo.all(query)
  end

  # Hardcoded PM10 limit is 100
  def countOverLimits(type) do
    limits = %{"PM10" => 100}
    case Map.has_key?(limits, type) do
      false -> IO.puts("There is no limit specified for this type of measurement!")
      true -> import Ecto.Query, only: [from: 2]

              query = from m in "measurements",
                           join: s in "stations", on: [id: m.station_id],
                           where: m.type == ^type and m.value > ^limits[type],
                           group_by: [s.name],
                           select: {s.name, count(m.value)}

              Pollution.Repo.all(query)
    end
  end

end
