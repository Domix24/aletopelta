defmodule Aletopelta.Year2021.Day07 do
  @moduledoc """
  Day 7 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """
    @spec parse_input([binary()]) :: [integer()]
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        ~r/\d+/
        |> Regex.scan(line)
        |> Enum.map(fn [number] -> String.to_integer(number) end)
      end)
      |> Enum.at(0)
    end

    @spec find_cheapest([integer()], [integer()], (integer() -> integer())) :: integer()
    def find_cheapest(positions, goals, cost_function) do
      find_cheapest(positions, goals, nil, cost_function)
    end

    defp find_cheapest(_, [], minimum, _), do: minimum

    defp find_cheapest(positions, [goal | others], minimum, cost_function) do
      new_minimum = calculate_cost(goal, positions, 0, minimum, cost_function)
      find_cheapest(positions, others, new_minimum, cost_function)
    end

    defp calculate_cost(_, _, cost, minimum, _) when cost > minimum and not is_nil(minimum),
      do: minimum

    defp calculate_cost(_, [], cost, _, _), do: cost

    defp calculate_cost(goal, [number | others], cost, minimum, cost_function) do
      append_cost =
        (goal - number)
        |> abs()
        |> cost_function.()

      calculate_cost(goal, others, cost + append_cost, minimum, cost_function)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_cheapest()
    end

    defp find_cheapest(positions),
      do: Common.find_cheapest(positions, positions, &calculate_cost/1)

    defp calculate_cost(distance), do: distance
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_cheapest()
    end

    defp find_cheapest(positions) do
      mean = div(Enum.sum(positions), Enum.count(positions))

      mean_list =
        -1
        |> Range.new(1)
        |> Range.shift(mean)
        |> Range.to_list()

      Common.find_cheapest(positions, mean_list, &calculate_cost/1)
    end

    defp calculate_cost(distance), do: div(distance * (distance + 1), 2)
  end
end
