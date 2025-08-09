defmodule Aletopelta.Year2019.Day16 do
  @moduledoc """
  Day 16 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> apply_fft(100)
      |> Enum.take(8)
      |> Integer.undigits()
    end

    defp apply_fft(numbers, 0), do: numbers

    defp apply_fft(numbers, count) do
      numbers
      |> Enum.with_index(fn _, index -> get_number(numbers, index + 1) end)
      |> apply_fft(count - 1)
    end

    defp get_number(numbers, index) do
      numbers
      |> Enum.drop(index - 1)
      |> do_sum(index, 1, 0)
      |> abs()
      |> rem(10)
    end

    defp do_sum([], _, _, sum), do: sum

    defp do_sum(numbers, size, factor, sum) do
      {inuse, notused} = Enum.split(numbers, size)

      new_sum = Enum.sum(inuse) * factor
      new_factor = if factor == 1, do: -1, else: 1

      notused
      |> Enum.drop(size)
      |> do_sum(size, new_factor, new_sum + sum)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> update_input(10_000)
      |> prepare(100)
      |> Enum.take(8)
      |> Integer.undigits()
    end

    defp update_input(numbers, repeat) do
      total = Enum.count(numbers) * repeat

      numbers
      |> Stream.cycle()
      |> Enum.take(total)
    end

    defp prepare(numbers, max) do
      target =
        numbers
        |> Enum.take(7)
        |> Integer.undigits()

      numbers
      |> Enum.drop(target)
      |> apply_reduce(max)
    end

    defp apply_reduce(numbers, 0), do: numbers

    defp apply_reduce(numbers, count) do
      numbers
      |> Enum.reverse()
      |> Enum.reduce([], fn
        number, [] -> [number]
        number, [last | _] = rest -> [rem(number + last, 10) | rest]
      end)
      |> apply_reduce(count - 1)
    end
  end
end
