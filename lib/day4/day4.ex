defmodule AdventOfCode2018.Day4 do
  def guard_most_asleep(file) do
    File.read!(file)
    |> parse_input()
    |> do_guard_most_asleep()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {year, month, day, hour, minute, token} =
        line
        |> String.split(
          ["[", "-", ":", "] ", "Guard #", " begins shift", "falls ", "wakes ", " "],
          trim: true
        )
        |> List.to_tuple()

      {String.to_integer(year), String.to_integer(month), String.to_integer(day),
       String.to_integer(hour), String.to_integer(minute), token}
    end)
    |> Enum.sort()
  end

  def do_guard_most_asleep(parsed_input) do
    guards_sleep_grid =
      parsed_input
      |> build_guards_sleep_grid()

    guard =
      guards_sleep_grid
      |> Enum.reduce(%{}, fn {{_year, _month, _day, guard_id}, minutes}, acc ->
        Map.update(acc, guard_id, Enum.count(minutes), fn old_minutes_asleep ->
          old_minutes_asleep + Enum.count(minutes)
        end)
      end)
      |> Enum.max_by(fn {_guard_id, minutes_asleep} -> minutes_asleep end)
      |> elem(0)

    minute_most_asleep =
      guards_sleep_grid
      |> Enum.filter(fn {{_year, _month, _day, guard_id}, _minutes} ->
        guard_id == guard
      end)
      |> Enum.reduce(%{}, fn {{_year, _month, _day, _guard_id}, minutes}, minutes_count ->
        Enum.reduce(minutes, minutes_count, fn m, m_count ->
          Map.update(m_count, m, 1, &(&1 + 1))
        end)
      end)
      |> Enum.max_by(fn {_minute, count} -> count end)
      |> elem(0)

    String.to_integer(guard) * minute_most_asleep
  end

  def build_guards_sleep_grid(parsed_input) do
    parsed_input
    |> Enum.reduce({"", -1, %{}}, fn {year, month, day, _hour, minute, token},
                                     {guard_id, asleep_since, guards_sleep_grid} ->
      case token do
        "asleep" ->
          {guard_id, minute, guards_sleep_grid}

        "up" ->
          {guard_id, -1,
           add_guard_sleep_time(
             {year, month, day, guard_id},
             asleep_since..(minute - 1),
             guards_sleep_grid
           )}

        guard_id ->
          {guard_id, asleep_since, guards_sleep_grid}
      end
    end)
    |> elem(2)
    |> Enum.map(fn {k, v} -> {k, Enum.sort(v)} end)
    |> Enum.into(%{})
  end

  def add_guard_sleep_time(key, minutes, guards_sleep_grid) do
    Enum.reduce(minutes, guards_sleep_grid, fn minute, acc ->
      Map.update(acc, key, [minute], fn old_minutes -> [minute | old_minutes] end)
    end)
  end

  def guard_most_asleep_on_same_minute(file) do
    File.read!(file)
    |> parse_input()
    |> do_guard_most_asleep_on_same_minute()
  end

  def do_guard_most_asleep_on_same_minute(parsed_input) do
    guards_sleep_grid =
      parsed_input
      |> build_guards_sleep_grid()

    {guard, minute_most_asleep} =
      guards_sleep_grid
      |> Enum.reduce(%{}, fn {{_year, _month, _day, guard_id}, minutes}, acc ->
        Enum.reduce(minutes, acc, fn minute, acc ->
          Map.update(acc, {guard_id, minute}, 1, &(&1 + 1))
        end)
      end)
      |> Enum.max_by(fn {{_guard_id, _minute}, count} -> count end)
      |> elem(0)

    String.to_integer(guard) * minute_most_asleep
  end
end
