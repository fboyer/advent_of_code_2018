defmodule AdventOfCode2018.Day5 do
  def units_remaining(file) do
    File.read!(file)
    |> parse_input()
    |> do_units_remaining()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.codepoints()
  end

  def do_units_remaining(parsed_input) do
    parsed_input
    |> react_polymer([])
    |> length()
  end

  def react_polymer([unit1, unit2 | rest], remaining_units) do
    cond do
      is_reacting?(unit1, unit2) == true ->
        if length(remaining_units) > 0 do
          [last_remaining_entry | new_remaining_units] = remaining_units
          react_polymer([last_remaining_entry | rest], new_remaining_units)
        else
          react_polymer(rest, remaining_units)
        end

      is_reacting?(unit1, unit2) == false ->
        react_polymer([unit2 | rest], [unit1 | remaining_units])
    end
  end

  def react_polymer([unit | []], remaining_units) do
    Enum.reverse([unit | remaining_units])
  end

  def react_polymer([], remaining_units) do
    Enum.reverse(remaining_units)
  end

  def is_reacting?(unit1, unit2) do
    cond do
      unit1 != unit2 && String.downcase(unit1) == String.downcase(unit2) ->
        true

      true ->
        false
    end
  end

  def shortest_polymer(file) do
    File.read!(file)
    |> do_shortest_polymer()
  end

  def do_shortest_polymer(input) do
    all_polymers = "abcdefghijklmnopqrstuvwxyz" |> String.codepoints()

    all_polymers
    |> Enum.reduce(nil, fn polymer, acc ->
      input
      |> remove_polymer(polymer)
      |> String.codepoints()
      |> react_polymer([])
      |> length()
      |> min(acc)
    end)
  end

  def remove_polymer(input, polymer) do
    input
    |> String.trim()
    |> String.replace([String.upcase(polymer), String.downcase(polymer)], "")
  end
end
