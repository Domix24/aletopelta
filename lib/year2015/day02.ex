defmodule Aletopelta.Year2015.Day02 do
  @moduledoc """
  Day 2 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(list(integer()))
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split("x")
        |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&formula/1)
    end

    defp formula([a, b, c]), do: formula(a * b, a * c, b * c)
    defp formula(a, b, c), do: Enum.min([a, b, c]) + 2 * a + 2 * b + 2 * c
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&formula/1)
    end

    defp formula(dimensions),
      do:
        dimensions
        |> Enum.sort()
        |> Enum.take(2)
        |> Enum.sum_by(&(&1 * 2))
        |> ribbon(dimensions)

    defp ribbon(wrap, dimensions), do: wrap + Enum.product(dimensions)
  end
end
