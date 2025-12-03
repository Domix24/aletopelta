defmodule Aletopelta.Year2025.Day02 do
  @moduledoc """
  Day 2 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(Range.t())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(fn line ->
        [first, last] =
          ~r"\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(& &1)
          |> Enum.map(&String.to_integer/1)

        first..last
      end)
    end

    @spec find_invalid(Range.t(), boolean()) :: Enumerable.t(list(number))
    def find_invalid(_..last//1 = range, part1? \\ true),
      do:
        1
        |> generate(range)
        |> Stream.iterate(&iterate(&1, range))
        |> Stream.take_while(&within?(&1, last))
        |> Stream.map(&only_within(&1, range, part1?))
        |> Stream.reject(&Enum.empty?/1)

    defp generate(number, _..last//1),
      do:
        "#{number}#{number}"
        |> String.to_integer()
        |> Stream.iterate(&String.to_integer("#{&1}#{number}"))
        |> Stream.take_while(&within?(&1, last))
        |> Enum.to_list()
        |> prepare(number)

    defp only_within({_, [numberlist | _]}, limits, true),
      do: Enum.filter([numberlist], &within?(&1, limits))

    defp only_within({_, numberlist}, limits, false),
      do: Enum.filter(numberlist, &within?(&1, limits))

    defp prepare(list, number), do: {number, list}

    defp iterate({number, _}, limits), do: generate(number + 1, limits)

    defp within?({_, [smallest | _]}, upper), do: smallest <= upper
    defp within?(number, _.._//1 = limits), do: number in limits
    defp within?(number, upper), do: number <= upper
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.flat_map(&process/1)
      |> Enum.sum()
    end

    defp process(list) do
      list
      |> Common.find_invalid(true)
      |> Enum.flat_map(& &1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.flat_map(&process/1)
      |> Enum.sum()
    end

    defp process(list) do
      list
      |> Common.find_invalid(false)
      |> Enum.flat_map(& &1)
      |> Enum.uniq()
    end
  end
end
