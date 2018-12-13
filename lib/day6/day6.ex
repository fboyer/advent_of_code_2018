defmodule AdventOfCode2018.Day6 do
  def largest_finite_area_size(file) do
    File.read!(file)
    |> parse_input()
    |> do_largest_finite_area_size()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn coordinate ->
      coordinate
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def do_largest_finite_area_size(coordinates) do
    infinite_coordinates = infinite_coordinates(coordinates)

    coordinates
    |> closest_grid()
    |> Enum.reject(fn {_location, coordinate} -> coordinate in infinite_coordinates end)
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    |> Enum.max_by(fn {_coordinate, area} -> Enum.count(area) end)
    |> elem(1)
    |> length()
  end

  def infinite_coordinates(coordinates) do
    {{x_min, y_min}, {x_max, y_max}} = bounding_box(coordinates)

    Enum.filter(coordinates, fn {x, y} -> x == x_min || x == x_max || y == y_min || y == y_max end)
  end

  def closest_grid(coordinates) do
    {{x_min, y_min}, {x_max, y_max}} = bounding_box(coordinates)

    for x <- x_min..x_max,
        y <- y_min..y_max,
        closest_coordinate = closest_coordinate(coordinates, {x, y}),
        into: %{} do
      {{x, y}, closest_coordinate}
    end
  end

  def bounding_box(coordinates) do
    {{x_min, _}, {x_max, _}} = Enum.min_max_by(coordinates, &elem(&1, 0))
    {{_, y_min}, {_, y_max}} = Enum.min_max_by(coordinates, &elem(&1, 1))

    {{x_min, y_min}, {x_max, y_max}}
  end

  def closest_coordinate(coordinates, location) do
    coordinates
    |> Enum.map(&{manhattan_distance(&1, location), &1})
    |> Enum.sort()
    |> case do
      [{distance, _}, {distance, _} | _] -> nil
      [{_, coordinate} | _] -> coordinate
    end
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def safe_area_size(file) do
    File.read!(file)
    |> parse_input()
    |> do_safe_area_size(10000)
  end

  def do_safe_area_size(coordinates, maximum_distance) do
    {{x_min, y_min}, {x_max, y_max}} = bounding_box(coordinates)

    Task.async_stream(x_min..x_max, fn x ->
      Enum.reduce(y_min..y_max, 0, fn y, acc ->
        if total_distance(coordinates, {x, y}) < maximum_distance do
          acc + 1
        else
          acc
        end
      end)
    end)
    |> Enum.reduce(0, fn {:ok, result}, acc ->
      acc + result
    end)
  end

  def total_distance(coordinates, location) do
    coordinates
    |> Enum.map(&manhattan_distance(&1, location))
    |> Enum.sum()
  end
end
