defmodule Aletopelta.Year2015.Day17 do
  @moduledoc """
  Day 17 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type sequence() :: list(integer())

    @spec parse_input(input()) :: sequence()
    def parse_input(input) do
      input
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
    end

    @spec combine(sequence(), integer()) :: list(sequence())
    def combine(_, 0), do: [[]]
    def combine([], _), do: []
    def combine(_, target) when target < 0, do: []

    def combine([head | tail], target) do
      with_head = for rest <- combine(tail, target - head), do: [head | rest]
      without_head = combine(tail, target)

      with_head ++ without_head
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.combine(150)
      |> Enum.count()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.combine(150)
      |> Enum.frequencies_by(&length(&1))
      |> Enum.min_by(&elem(&1, 0))
      |> elem(1)
    end
  end
end
