defmodule AdventOfCode2018.Day6Test do
  use ExUnit.Case

  import AdventOfCode2018.Day6

  test "parse_input" do
    assert parse_input("""
           1, 1
           1, 6
           8, 3
           3, 4
           5, 5
           8, 9
           """) == [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]
  end

  test "do_largest_finite_area_size" do
    assert do_largest_finite_area_size([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]) == 17
  end

  test "infinite_coordinate" do
    assert infinite_coordinates([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]) == [
             {1, 1},
             {1, 6},
             {8, 3},
             {8, 9}
           ]
  end

  test "closest_grid" do
    assert closest_grid([{1, 1}, {3, 3}]) == %{
             {1, 1} => {1, 1},
             {1, 2} => {1, 1},
             {2, 1} => {1, 1},
             {2, 3} => {3, 3},
             {3, 2} => {3, 3},
             {3, 3} => {3, 3}
           }
  end

  test "bounding_box" do
    assert bounding_box([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]) == {{1, 1}, {8, 9}}
  end

  test "closest_coordinate" do
    assert closest_coordinate([{1, 1}, {3, 3}], {1, 1}) == {1, 1}
    assert closest_coordinate([{1, 1}, {3, 3}], {3, 2}) == {3, 3}
    assert closest_coordinate([{1, 1}, {3, 3}], {2, 2}) == nil
  end

  test "manhattan_distance" do
    assert manhattan_distance({0, 0}, {1, 1}) == 2
    assert manhattan_distance({-4, 0}, {1, -5}) == 10
  end

  test "do_safe_area_size" do
    assert do_safe_area_size([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}], 32) == 16
  end

  test "total_distance" do
    assert total_distance([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}], {4, 3}) == 30
  end
end
