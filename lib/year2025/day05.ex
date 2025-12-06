defmodule Aletopelta.Year2025.Day05 do
  @moduledoc """
  Day 5 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: %{ranges: list(Range.t()), ids: list(integer())}
    def parse_input(input) do
      input
      |> Enum.reduce({%{ranges: [], ids: []}, 0}, fn
        "", {acc, 0} ->
          {acc, 1}

        range, {%{ranges: ranges, ids: []}, 0} ->
          [first, last] =
            range
            |> String.split("-")
            |> Enum.map(&String.to_integer/1)

          {%{ranges: [first..last//1 | ranges], ids: []}, 0}

        id, {%{ranges: ranges, ids: ids}, 1} ->
          {%{ranges: ranges, ids: [String.to_integer(id) | ids]}, 1}
      end)
      |> elem(0)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(%{ranges: ranges, ids: ids}), do: Enum.count(ids, &fresh?(&1, ranges))

    defp fresh?(id, ranges), do: Enum.any?(ranges, &(id in &1))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Map.fetch!(:ranges)
      |> Enum.sort_by(fn first..last//_ -> {first, last} end)
      |> Enum.reduce([], &process/2)
      |> Enum.sum_by(&Range.size/1)
    end

    defp process(first..last//1, [acc_first..acc_last//1 | rest])
         when first in acc_first..acc_last//1, do: [acc_first..max(acc_last, last) | rest]

    defp process(range, acc), do: [range | acc]
  end
end
