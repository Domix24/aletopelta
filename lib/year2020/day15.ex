defmodule Aletopelta.Year2020.Day15 do
  @moduledoc """
  Day 15 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type output() :: list(integer())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    @spec speak_numbers(output(), integer()) :: integer()
    def speak_numbers(starting, limit) do
      starting
      |> initialize()
      |> do_loop(limit)
    end

    defp initialize([], turn, acc, last), do: {acc, last, turn}

    defp initialize([start | others], turn, acc, _),
      do: initialize(others, turn + 1, Map.put(acc, start, {turn, -1}), start)

    defp initialize(starting), do: initialize(starting, 1, Map.new(), nil)

    defp do_loop({map, last, turn}, max) do
      map
      |> Map.get(last, 0)
      |> say_number()
      |> update_map(map, turn)
      |> continue(turn, max)
    end

    defp say_number({_, -1}), do: 0
    defp say_number({turn1, turn2}), do: turn1 - turn2

    defp update_map(number, map, turn),
      do: {number, Map.update(map, number, {turn, -1}, fn {old_turn, _} -> {turn, old_turn} end)}

    defp continue({last, _}, max, max), do: last
    defp continue({last, map}, turn, max), do: do_loop({map, last, turn + 1}, max)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.speak_numbers(2020)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.speak_numbers(30_000_000)
    end
  end
end
