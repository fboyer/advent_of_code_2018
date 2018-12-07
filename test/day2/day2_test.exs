defmodule AdventOfCode2018.Day2Test do
  use ExUnit.Case

  import AdventOfCode2018.Day2

  test "parse_input" do
    assert parse_input("""
           abcdef
           bababc
           abbcde
           abcccd
           aabcdd
           abcdee
           ababab
           """) == [
             ["a", "b", "c", "d", "e", "f"],
             ["b", "a", "b", "a", "b", "c"],
             ["a", "b", "b", "c", "d", "e"],
             ["a", "b", "c", "c", "c", "d"],
             ["a", "a", "b", "c", "d", "d"],
             ["a", "b", "c", "d", "e", "e"],
             ["a", "b", "a", "b", "a", "b"]
           ]
  end

  test "count_letters" do
    assert count_letters(["b", "a", "b", "a", "b", "c"]) == [
             {"a", 2},
             {"b", 3},
             {"c", 1}
           ]
  end

  test "contains_letter_seen_twice?" do
    assert contains_letter_seen_twice?([
             {"a", 1},
             {"b", 1},
             {"c", 1},
             {"d", 1},
             {"e", 1},
             {"f", 1}
           ]) == 0

    assert contains_letter_seen_twice?([
             {"a", 1},
             {"b", 2},
             {"c", 1},
             {"d", 1},
             {"e", 1}
           ]) == 1

    assert contains_letter_seen_twice?([
             {"a", 1},
             {"b", 1},
             {"c", 3},
             {"d", 1}
           ]) == 0

    assert contains_letter_seen_twice?([
             {"a", 2},
             {"b", 3},
             {"c", 1}
           ]) == 1
  end

  test "contains_letter_seen_thrice?" do
    assert contains_letter_seen_thrice?([
             {"a", 1},
             {"b", 1},
             {"c", 1},
             {"d", 1},
             {"e", 1},
             {"f", 1}
           ]) == 0

    assert contains_letter_seen_thrice?([
             {"a", 1},
             {"b", 2},
             {"c", 1},
             {"d", 1},
             {"e", 1}
           ]) == 0

    assert contains_letter_seen_thrice?([
             {"a", 1},
             {"b", 1},
             {"c", 3},
             {"d", 1}
           ]) == 1

    assert contains_letter_seen_thrice?([
             {"a", 2},
             {"b", 3},
             {"c", 1}
           ]) == 1
  end

  test "do_checksum" do
    assert do_checksum([
             ["a", "b", "c", "d", "e", "f"],
             ["b", "a", "b", "a", "b", "c"],
             ["a", "b", "b", "c", "d", "e"],
             ["a", "b", "c", "c", "c", "d"],
             ["a", "a", "b", "c", "d", "d"],
             ["a", "b", "c", "d", "e", "e"],
             ["a", "b", "a", "b", "a", "b"]
           ]) == 12
  end

  test "common_letters_and_diff_count" do
    assert common_letters_and_diff_count(
             ["a", "b", "c", "d", "e"],
             ["f", "g", "h", "i", "j"]
           ) == {[], 5}

    assert common_letters_and_diff_count(
             ["a", "b", "c", "d", "e"],
             ["a", "x", "c", "y", "e"]
           ) == {["a", "c", "e"], 2}

    assert common_letters_and_diff_count(
             ["f", "g", "h", "i", "j"],
             ["f", "g", "u", "i", "j"]
           ) == {["f", "g", "i", "j"], 1}
  end

  test "common_letters_with_one_diff" do
    assert common_letters_with_one_diff(
      ["a", "b", "c", "d", "e"],
      [
        ["f", "g", "h", "i", "j"],
        ["k", "l", "m", "n", "o"],
        ["p", "q", "r", "s", "t"],
        ["f", "g", "u", "i", "j"],
        ["a", "x", "c", "y", "e"],
        ["w", "v", "x", "y", "z"]
      ], {[], 0}) == []

      assert common_letters_with_one_diff(
        ["f", "g", "h", "i", "j"],
        [
          ["k", "l", "m", "n", "o"],
          ["p", "q", "r", "s", "t"],
          ["f", "g", "u", "i", "j"],
          ["a", "x", "c", "y", "e"],
          ["w", "v", "x", "y", "z"]
        ], {[], 0}) == ["f", "g", "i", "j"]
  end

  test "compare_all_box_ids" do
    assert compare_all_box_ids([
      ["a", "b", "c", "d", "e"],
      ["f", "g", "h", "i", "j"],
      ["k", "l", "m", "n", "o"],
      ["p", "q", "r", "s", "t"],
      ["f", "g", "u", "i", "j"],
      ["a", "x", "c", "y", "e"],
      ["w", "v", "x", "y", "z"]
    ], []) == ["f", "g", "i", "j"]
  end

  test "do_find_two_correct_boxes" do
    assert do_find_two_correct_boxes([
      ["a", "b", "c", "d", "e"],
      ["f", "g", "h", "i", "j"],
      ["k", "l", "m", "n", "o"],
      ["p", "q", "r", "s", "t"],
      ["f", "g", "u", "i", "j"],
      ["a", "x", "c", "y", "e"],
      ["w", "v", "x", "y", "z"]
    ]) == "fgij"
  end
end
