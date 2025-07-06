defmodule Aletopelta.Year2020.Day01 do
  @moduledoc """
  Day 1 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec combine(list(), integer()) :: list(list())
    def combine(list, count), do: do_combine(list, count)

    defp do_combine(_, 0), do: [[]]
    defp do_combine([], _), do: []

    defp do_combine([head | tail], count) do
      with_head =
        tail
        |> do_combine(count - 1)
        |> Stream.map(&[head | &1])

      without_head = do_combine(tail, count)
      Stream.concat(with_head, without_head)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> MapSet.new()
      |> find_sum()
      |> Enum.product()
    end

    defp find_sum(numbers) do
      for number <- numbers,
          complement = 2020 - number,
          complement != number,
          MapSet.member?(numbers, complement),
          reduce: nil do
        nil -> [number, complement]
        acc -> acc
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> MapSet.new()
      |> find_sum()
      |> Enum.product()
    end

    defp find_sum(numbers) do
      for {number1, i} <- Enum.with_index(numbers),
          {number2, j} <- Enum.with_index(numbers),
          complement = 2020 - number1 - number2,
          complement > 0,
          j > i,
          MapSet.member?(numbers, complement),
          reduce: nil do
        nil -> [number1, number2, complement]
        acc -> acc
      end
    end
  end
end
