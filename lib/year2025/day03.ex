defmodule Aletopelta.Year2025.Day03 do
  @moduledoc """
  Day 3 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(integer()))
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.to_charlist()
        |> Enum.map(&(&1 - ?0))
      end)
    end

    @spec joltage(list(integer()), integer(), list(integer())) :: integer()
    def joltage(battery, count, accumulator \\ [])

    def joltage(_, 0, accumulator),
      do:
        accumulator
        |> Enum.reverse()
        |> Integer.undigits()

    def joltage(battery, count, accumulator) do
      {space, complete} = split(battery, -count + 1)

      max = Enum.max(space)
      [^max | others] = Enum.drop_while(space, &(&1 != max))

      joltage(others ++ complete, count - 1, [max | accumulator])
    end

    defp split(list, 0), do: {list, []}
    defp split(list, amount), do: Enum.split(list, amount)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&Common.joltage(&1, 2))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&Common.joltage(&1, 12))
    end
  end
end
