defmodule AdventOfCode2018.Day2 do
  def checksum(file) do
    File.read!(file)
    |> parse_input()
    |> do_checksum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  def do_checksum(parsed_input) do
    {twice, thrice} =
      parsed_input
      |> Enum.map(&count_letters/1)
      |> Enum.reduce({0, 0}, fn letter_count, {twice, thrice} ->
        {twice + contains_letter_seen_twice?(letter_count),
         thrice + contains_letter_seen_thrice?(letter_count)}
      end)

    twice * thrice
  end

  def count_letters(letters) do
    letters
    |> Enum.reduce(%{}, fn letter, letters_count ->
      Map.update(letters_count, letter, 1, fn count -> count + 1 end)
    end)
    |> Map.to_list()
  end

  def contains_letter_seen_twice?(letters_count) do
    letters_count
    |> Enum.any?(fn {_letter, count} -> count == 2 end)
    |> case do
      true ->
        1

      false ->
        0
    end
  end

  def contains_letter_seen_thrice?(letters_count) do
    letters_count
    |> Enum.any?(fn {_letter, count} -> count == 3 end)
    |> case do
      true ->
        1

      false ->
        0
    end
  end

  def find_two_correct_boxes(file) do
    File.read!(file)
    |> parse_input()
    |> do_find_two_correct_boxes()
  end

  def do_find_two_correct_boxes(parsed_input) do
    parsed_input
    |> compare_all_box_ids([])
    |> Enum.join()
  end

  def compare_all_box_ids([_box_id | []], []) do
    []
  end

  def compare_all_box_ids([box_id | rest], []) do
    compare_all_box_ids(rest, common_letters_with_one_diff(box_id, rest, {[], 0}))
  end

  def compare_all_box_ids(_rest, common_letters) do
    common_letters
  end

  def common_letters_with_one_diff(_box_id, _rest, {common_letters, 1}) do
    common_letters
  end

  def common_letters_with_one_diff(_box_id, [], _prev_comparison) do
    []
  end

  def common_letters_with_one_diff(box_id, [next_box_id | rest], _prev_comparison) do
    common_letters_with_one_diff(box_id, rest, common_letters_and_diff_count(box_id, next_box_id))
  end

  def common_letters_and_diff_count(box_id, other_box_id) do
    {common_letters, diff_count} =
      Enum.zip(box_id, other_box_id)
      |> Enum.reduce({[], 0}, fn {letter_box_id, letter_other_box_id},
                                 {common_letters, diff_count} ->
        if letter_box_id == letter_other_box_id do
          {[letter_box_id | common_letters], diff_count}
        else
          {common_letters, diff_count + 1}
        end
      end)

    {Enum.reverse(common_letters), diff_count}
  end
end
