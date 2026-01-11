defmodule Aletopelta.Year2016.Day20 do
  @moduledoc """
  Day 20 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(Range.t())
    def parse_input(input) do
      Enum.map(input, fn line ->
        [first, last] =
          ~r"\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(& &1)
          |> Enum.map(&String.to_integer/1)

        first..last
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sort()
      |> Enum.reduce(0, fn
        first..last//1, number when number in first..last//1 -> last + 1
        _, number -> number
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sort()
      |> Enum.reduce(nil, fn
        range, nil ->
          {range, 2 ** 32}

        first..last//1 = range, {acc_first..acc_last//1 = acc_range, total} ->
          if first > acc_last + 1 do
            {range, total - Range.size(acc_range)}
          else
            {acc_first..max(acc_last, last)//1, total}
          end
      end)
      |> process()
    end

    defp process({range, total}), do: total - Range.size(range)
  end
end
