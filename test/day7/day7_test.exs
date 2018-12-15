defmodule AdventOfCode2018.Day7Test do
  use ExUnit.Case

  import AdventOfCode2018.Day7

  test "parse_input" do
    assert parse_input("""
           Step C must be finished before step A can begin.
           Step C must be finished before step F can begin.
           Step A must be finished before step B can begin.
           Step A must be finished before step D can begin.
           Step B must be finished before step E can begin.
           Step D must be finished before step E can begin.
           Step F must be finished before step E can begin.
           """) == [
             {"A", ["C"]},
             {"B", ["A"]},
             {"C", []},
             {"D", ["A"]},
             {"E", ["B", "D", "F"]},
             {"F", ["C"]}
           ]
  end

  test "do_follow_instructions" do
    assert do_follow_instructions([
             {"A", ["C"]},
             {"B", ["A"]},
             {"C", []},
             {"D", ["A"]},
             {"E", ["B", "D", "F"]},
             {"F", ["C"]}
           ]) == "CABDFE"
  end

  test "do_time_to_complete_instructions" do
    assert do_time_to_complete_instructions(
             [
               {"A", ["C"]},
               {"B", ["A"]},
               {"C", []},
               {"D", ["A"]},
               {"E", ["B", "D", "F"]},
               {"F", ["C"]}
             ],
             2,
             0
           ) == 15
  end

  test "find_all_completed_steps" do
    assert find_all_completed_steps([{"C", 3}], 3, []) == ["C"]
    assert find_all_completed_steps([{"F", 9}, {"A", 4}], 4, []) == ["A"]
  end

  test "complete_work" do
    assert complete_work(1, [], 3, [{"C", 3}]) == {2, ["C"], []}
    assert complete_work(0, ["C"], 4, [{"F", 9}, {"A", 4}]) == {1, ["C", "A"], [{"F", 9}]}
  end

  test "find_all_available_steps" do
    assert find_all_available_steps(
             [
               {"A", ["C"]},
               {"B", ["A"]},
               {"C", []},
               {"D", ["A"]},
               {"E", ["B", "D", "F"]},
               {"F", ["C"]}
             ],
             [],
             []
           ) == ["C"]

    assert find_all_available_steps(
             [
               {"A", ["C"]},
               {"B", ["A"]},
               {"D", ["A"]},
               {"E", ["B", "D", "F"]},
               {"F", ["C"]}
             ],
             ["C"],
             []
           ) == ["A", "F"]
  end

  test "dispatch_work" do
    assert dispatch_work(
             [
               {"A", ["C"]},
               {"B", ["A"]},
               {"D", ["A"]},
               {"E", ["B", "D", "F"]},
               {"F", ["C"]}
             ],
             2,
             0,
             3,
             ["C"],
             []
           ) == {[{"B", ["A"]}, {"D", ["A"]}, {"E", ["B", "D", "F"]}], 0, [{"F", 9}, {"A", 4}]}

    assert dispatch_work(
             [
               {"B", ["A"]},
               {"C", ["A"]},
               {"D", ["A"]}
             ],
             2,
             0,
             3,
             ["A"],
             []
           ) == {[{"D", ["A"]}], 0, [{"C", 6}, {"B", 5}]}
  end

  test "time_to_complete_step" do
    assert time_to_complete_step("A", 60) == 61
    assert time_to_complete_step("Z", 60) == 86
  end
end
