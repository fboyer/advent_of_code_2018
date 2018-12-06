defmodule AdventOfCode2018.Day1Test do
  use ExUnit.Case

  import AdventOfCode2018.Day1

  test "do_resulting_frequency" do
    assert do_resulting_frequency("""
           +1
           -2
           +3
           +1
           """) == 3

    assert do_resulting_frequency("""
           +1
           +1
           +1
           """) == 3

    assert do_resulting_frequency("""
           +1
           +1
           -2
           """) == 0

    assert do_resulting_frequency("""
           -1
           -2
           -3
           """) == -6
  end

  test "do_repeating_frequency" do
    assert do_repeating_frequency("""
           +1
           -2
           +3
           +1
           """) == 2
  end
end
