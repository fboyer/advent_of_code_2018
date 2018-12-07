defmodule AdventOfCode2018.Day1 do
  def resulting_frequency(file) do
    File.read!(file)
    |> parse_input()
    |> do_resulting_frequency()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def do_resulting_frequency(parsed_input) do
    parsed_input
    |> Enum.sum()
  end

  def repeating_frequency(file) do
    File.read!(file)
    |> parse_input()
    |> do_repeating_frequency()
  end

  def do_repeating_frequency(parsed_input) do
    parsed_input
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {prev_freq, known_freq} ->
      next_freq = prev_freq + x

      case MapSet.member?(known_freq, next_freq) do
        false ->
          {:cont, {next_freq, MapSet.put(known_freq, next_freq)}}

        true ->
          {:halt, next_freq}
      end
    end)
  end
end
