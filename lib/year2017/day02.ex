defmodule Aletopelta.Year2017.Day02 do
  @moduledoc """
  Day 2 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split("\t")
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
      |> Enum.sum_by(&mapper/1)
    end

    defp mapper(line) do
      {min, max} = Enum.min_max(line)
      max - min
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&mapper/1)
    end

    defp mapper([number | rest]) do
      case find_evenly(number, rest) do
        nil -> mapper(rest)
        number -> number
      end
    end

    defp find_evenly(a, [b | _]) when rem(a, b) === 0, do: div(a, b)
    defp find_evenly(a, [b | _]) when rem(b, a) === 0, do: div(b, a)
    defp find_evenly(a, [_ | rest]), do: find_evenly(a, rest)
    defp find_evenly(_, []), do: nil
  end
end
