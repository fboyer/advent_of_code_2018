defmodule AdventOfCode2018.Day7 do
  def follow_instructions(file) do
    File.read!(file)
    |> parse_input()
    |> do_follow_instructions()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &String.split(&1, ["Step ", " must be finished before step ", " can begin."], trim: true)
    )
    |> List.flatten()
    |> build_requirements(%{})
  end

  def build_requirements([], requirements) do
    requirements
    |> Enum.sort()
    |> Enum.map(fn {k, v} -> {k, Enum.sort(v)} end)
  end

  def build_requirements([requirement, step | rest], requirements) do
    new_requirements =
      requirements
      |> Map.update(step, [requirement], fn step_requirements ->
        [requirement | step_requirements]
      end)
      |> Map.put_new(requirement, [])

    build_requirements(rest, new_requirements)
  end

  def do_follow_instructions(instructions) do
    instructions
    |> order_steps([])
    |> Enum.join()
  end

  def order_steps([], completed_steps) do
    Enum.reverse(completed_steps)
  end

  def order_steps(instructions, completed_steps) do
    {step, requirements} = find_next_step(instructions, completed_steps)

    new_instructions = List.delete(instructions, {step, requirements})

    order_steps(new_instructions, [step | completed_steps])
  end

  def find_next_step([{step, requirements} | rest], completed_steps) do
    requirements_fulfilled =
      requirements
      |> Enum.all?(fn requirement ->
        Enum.member?(completed_steps, requirement)
      end)

    if requirements_fulfilled do
      {step, requirements}
    else
      find_next_step(rest, completed_steps)
    end
  end

  def time_to_complete_instructions(file, workers, base_time_per_step) do
    File.read!(file)
    |> parse_input()
    |> do_time_to_complete_instructions(workers, base_time_per_step)
  end

  def do_time_to_complete_instructions(instructions, workers, base_time_per_step) do
    do_the_work(instructions, workers, base_time_per_step, 0, [], [])
  end

  def do_the_work([], _available_workers, _base_time_per_step, time, _completed_steps, []) do
    time - 1
  end

  def do_the_work(
        instructions,
        available_workers,
        base_time_per_step,
        time,
        completed_steps,
        steps_in_progress
      ) do
    {new_available_workers, new_completed_steps, new_steps_in_progress} =
      complete_work(available_workers, completed_steps, time, steps_in_progress)

    {new_instructions, new_available_workers, new_steps_in_progress} =
      dispatch_work(
        instructions,
        new_available_workers,
        base_time_per_step,
        time,
        new_completed_steps,
        new_steps_in_progress
      )

    do_the_work(
      new_instructions,
      new_available_workers,
      base_time_per_step,
      time + 1,
      new_completed_steps,
      new_steps_in_progress
    )
  end

  def complete_work(available_workers, completed_steps, time, steps_in_progress) do
    newly_completed_steps = find_all_completed_steps(steps_in_progress, time, [])

    new_completed_steps = completed_steps ++ newly_completed_steps

    new_steps_in_progress =
      Enum.reject(steps_in_progress, fn {step, _completion_time} ->
        Enum.member?(newly_completed_steps, step)
      end)

    new_available_workers = available_workers + Enum.count(newly_completed_steps)

    {new_available_workers, new_completed_steps, new_steps_in_progress}
  end

  def find_all_completed_steps([], _time, completed_steps) do
    completed_steps
  end

  def find_all_completed_steps([{step, completion_time} | rest], time, completed_steps) do
    if completion_time == time do
      find_all_completed_steps(rest, time, [step | completed_steps])
    else
      find_all_completed_steps(rest, time, completed_steps)
    end
  end

  def dispatch_work(
        instructions,
        available_workers,
        base_time_per_step,
        time,
        completed_steps,
        steps_in_progress
      ) do
    available_steps = find_all_available_steps(instructions, completed_steps, [])

    number_of_available_steps_starting = min(Enum.count(available_steps), available_workers)

    steps_starting = Enum.take(available_steps, number_of_available_steps_starting)

    new_steps_in_progress =
      Enum.reduce(steps_starting, steps_in_progress, fn step, acc ->
        [{step, time + time_to_complete_step(step, base_time_per_step)} | acc]
      end)

    new_instructions =
      Enum.reject(instructions, fn {step, _requirements} -> Enum.member?(steps_starting, step) end)

    new_available_workers = available_workers - number_of_available_steps_starting

    {new_instructions, new_available_workers, new_steps_in_progress}
  end

  def find_all_available_steps([], _completed_steps, available_steps) do
    Enum.reverse(available_steps)
  end

  def find_all_available_steps([{step, requirements} | rest], completed_steps, available_steps) do
    requirements_fulfilled =
      requirements
      |> Enum.all?(fn requirement ->
        Enum.member?(completed_steps, requirement)
      end)

    if requirements_fulfilled do
      find_all_available_steps(rest, completed_steps, [step | available_steps])
    else
      find_all_available_steps(rest, completed_steps, available_steps)
    end
  end

  def time_to_complete_step(step, base_time_per_step) do
    additional_time_for_step = List.first(String.to_charlist(step)) - ?A + 1

    base_time_per_step + additional_time_for_step
  end
end
