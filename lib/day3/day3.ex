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
    |> Enum.filter(fn {_pos, claim_count} -> claim_count > 1 end)
    |> Enum.count()
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
    claim_intact =
      Enum.all?((left + 1)..(left + width), fn x ->
        Enum.all?((top + 1)..(top + height), fn y ->
          Map.fetch!(expanded_claims, {x, y}) == 1
        end)
      end)

    {id, claim_intact}
  end
end
