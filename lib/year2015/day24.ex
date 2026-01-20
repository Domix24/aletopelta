defmodule Aletopelta.Year2015.Day24 do
  @moduledoc """
  Day 24 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec execute(list(integer()), integer()) :: output()
    def execute(numbers, size),
      do:
        numbers
        |> Enum.sum()
        |> div(size)
        |> execute(numbers, :internal)
        |> Enum.min_by(&Enum.product/1)
        |> Enum.product()

    defp execute(group_size, numbers, :internal),
      do:
        1
        |> Stream.iterate(&(&1 + 1))
        |> Stream.map(fn size ->
          numbers
          |> combination(size)
          |> Enum.filter(&(Enum.sum(&1) === group_size))
        end)
        |> Enum.find(fn
          [] -> false
          _ -> true
        end)

    defp combination(_, 0), do: [[]]
    defp combination([], _), do: []

    defp combination([head | tail], k) do
      with_head = for rest <- combination(tail, k - 1), do: [head | rest]
      with_head ++ combination(tail, k)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(3)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(4)
    end
  end
end
