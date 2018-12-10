defmodule AdventOfCode2018.Day5Test do
  use ExUnit.Case

  import AdventOfCode2018.Day5

  test "parse_input" do
    assert parse_input("dabAcCaCBAcCcaDA") == [
             "d",
             "a",
             "b",
             "A",
             "c",
             "C",
             "a",
             "C",
             "B",
             "A",
             "c",
             "C",
             "c",
             "a",
             "D",
             "A"
           ]
  end

  test "is_reacting?" do
    assert is_reacting?("a", "A") == true
    assert is_reacting?("A", "a") == true
    assert is_reacting?("a", "a") == false
    assert is_reacting?("A", "A") == false
    assert is_reacting?("a", "B") == false
    assert is_reacting?("A", "b") == false
    assert is_reacting?("a", "b") == false
    assert is_reacting?("A", "B") == false
  end

  test "react_polymer" do
    assert react_polymer(
             ["d", "a", "b", "A", "c", "C", "a", "C", "B", "A", "c", "C", "c", "a", "D", "A"],
             []
           ) == ["d", "a", "b", "C", "B", "A", "c", "a", "D", "A"]
  end

  test "do_units_remaining" do
    assert do_units_remaining([
             "d",
             "a",
             "b",
             "A",
             "c",
             "C",
             "a",
             "C",
             "B",
             "A",
             "c",
             "C",
             "c",
             "a",
             "D",
             "A"
           ]) == 10
  end

  test "remove_polymer" do
    assert remove_polymer("dabAcCaCBAcCcaDA", "a") == "dbcCCBcCcD"
    assert remove_polymer("dabAcCaCBAcCcaDA", "b") == "daAcCaCAcCcaDA"
    assert remove_polymer("dabAcCaCBAcCcaDA", "c") == "dabAaBAaDA"
    assert remove_polymer("dabAcCaCBAcCcaDA", "d") == "abAcCaCBAcCcaA"
  end

  test "do_shortest_polymer" do
    assert do_shortest_polymer("dabAcCaCBAcCcaDA") == 4
  end
end
