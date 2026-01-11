defmodule Aletopelta.Year2016.Day18 do
  @moduledoc """
  Day 18 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&to_number/1)
    end

    defp to_number("."), do: 1
    defp to_number("^"), do: 0

    @spec execute(list(integer()), integer()) :: output()
    def execute(row, size),
      do:
        row
        |> Stream.iterate(&create/1)
        |> Enum.take(size)
        |> Enum.sum_by(&Enum.sum/1)

    defp create([_ | rest] = list), do: create([1 | list], rest)

    defp create([state | rest1], [state | rest2]), do: [1 | create(rest1, rest2)]
    defp create([1 | _], []), do: [1]
    defp create(_, []), do: [0]
    defp create([_ | rest1], [_ | rest2]), do: [0 | create(rest1, rest2)]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(40)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(400_000)
    end
  end
end
