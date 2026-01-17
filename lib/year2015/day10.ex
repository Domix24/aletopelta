defmodule Aletopelta.Year2015.Day10 do
  @moduledoc """
  Day 10 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type sequence() :: list(integer())

    @spec parse_input(input()) :: sequence()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end

    @spec execute(sequence(), integer()) :: output()
    def execute(input, index),
      do:
        input
        |> Stream.iterate(&iterate/1)
        |> Enum.at(index)
        |> Enum.count()

    defp iterate([]), do: []

    defp iterate([number | rest]) do
      {count, new_rest} = iterate(rest, number, 1)
      [count, number | iterate(new_rest)]
    end

    defp iterate([number | rest], number, count), do: iterate(rest, number, count + 1)
    defp iterate(list, _, count), do: {count, list}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
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
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(50)
    end
  end
end
