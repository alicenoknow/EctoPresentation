defmodule PollutionData do

  def importLinesFromCSV(filename \\ "pollution.csv") do
    File.read!(filename) |> String.split("\r\n")
  end

  def parseLine(line) do

    [raw_date, raw_time, raw_latitude, raw_longitude, raw_value] = line |> String.split(",")

    date = raw_date |> String.split("-")
           |> Enum.reverse
           |> Enum.map(&String.to_integer/1)
           |> :erlang.list_to_tuple

    time = raw_time |> String.split(":")
           |> Enum.map(&String.to_integer/1)
           |> :erlang.list_to_tuple

    time = if elem(time, 1) == 60 do {elem(time, 0), 0} else {elem(time, 0), elem(time, 1)} end

    case NaiveDateTime.new(elem(date, 0), elem(date, 1), elem(date, 2), elem(time, 0), elem(time, 1), 0) do
      {:ok, datetime} -> %{:datetime => datetime,
                          :location => {String.to_float(raw_latitude),
                            String.to_float(raw_longitude)},
                          :pollutionLevel => String.to_integer(raw_value)}
      {:error, _} -> IO.puts("Invalid data: #{elem(date, 0)}, #{elem(date, 1)}, #{elem(date, 2)}, #{elem(time, 0)}, #{elem(time, 1)}")

    end
  end

  def identifyStations(records) do
    Enum.uniq_by(records, fn x -> x.location end)
  end

  def createStationName(record) do
    {"station_#{elem(record.location, 0)}_#{elem(record.location, 1)}", record.location}
  end

  def createStations(records) do
    records |> identifyStations()
    |> Enum.map(fn x -> createStationName(x) end)
    |> Enum.each(fn {name, location}
    -> Pollution.addStation(name, location) end)
  end

  def addMeasurements(measurements) do
    measurements
    |> Enum.each(fn x ->
    Pollution.addValue(x.location, x.datetime, "PM10", x.pollutionLevel)
    end)
  end

  def importData() do
    data = importLinesFromCSV()
    records = for line <- data, do: parseLine(line)
    createStations(records)
    addMeasurements(records)
  end

end