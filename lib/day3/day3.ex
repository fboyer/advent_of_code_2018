defmodule AdventOfCode2018.Day3 do
  def overlapped_square_inches(file) do
    File.read!(file)
    |> parse_input()
    |> do_overlapped_square_inches()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def do_overlapped_square_inches(parsed_input) do
    parsed_input
    |> expand_claims()
    |> Enum.reduce(0, fn {_pos, claim_count}, total_overlapped_square_inches ->
      if claim_count > 1 do
        total_overlapped_square_inches + 1
      else
        total_overlapped_square_inches
      end
    end)
  end

  def expand_claims(claims) do
    claims
    |> Enum.reduce(%{}, &expand_claim(&1, &2))
  end

  def expand_claim({_id, left, top, width, height}, expanded_claims) do
    Enum.reduce((left + 1)..(left + width), expanded_claims, fn x, expanded_claims ->
      Enum.reduce((top + 1)..(top + height), expanded_claims, fn y, expanded_claims ->
        Map.update(expanded_claims, {x, y}, 1, fn x -> x + 1 end)
      end)
    end)
  end

  def intact_claim(file) do
    File.read!(file)
    |> parse_input()
    |> do_intact_claim()
  end

  def do_intact_claim(parsed_input) do
    expanded_claims =
      parsed_input
      |> expand_claims()

    parsed_input
    |> Enum.map(&is_claim_intact?(&1, expanded_claims))
    |> Enum.find(fn {_id, claim_intact} -> claim_intact == true end)
    |> elem(0)
  end

  def is_claim_intact?({id, left, top, width, height}, expanded_claims) do
    Enum.reduce_while((left + 1)..(left + width), {id, true}, fn x, _claim_intact ->
      Enum.reduce_while((top + 1)..(top + height), {id, true}, fn y, _claim_intact ->
        if Map.fetch!(expanded_claims, {x, y}) == 1 do
          {:cont, {id, true}}
        else
          {:halt, {id, false}}
        end
      end)
      |> case do
        {id, true} ->
          {:cont, {id, true}}

          {id, false} ->
          {:halt, {id, false}}
      end
    end)
  end
end
