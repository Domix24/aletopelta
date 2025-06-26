defmodule Aletopelta.Year2021.Day24 do
  @moduledoc """
  Day 24 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: [binary()]
    @type output() :: [[binary()]]

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      firstline = Enum.at(input, 0)

      input
      |> Enum.chunk_by(&(&1 == firstline))
      |> Enum.chunk_every(2)
      |> Enum.map(fn [_, rest] -> rest end)
    end

    @spec do_execute(output(), :high | :low) :: integer()
    def do_execute(input, type) do
      input
      |> remove_duplicate()
      |> Enum.map(&extract_numbers/1)
      |> Enum.zip()
      |> Enum.with_index(&add_index/2)
      |> order_stack()
      |> Enum.flat_map(&find_digit(&1, type))
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map_join(&elem(&1, 1))
      |> String.to_integer()
    end

    defp remove_duplicate([[] | _]), do: []

    defp remove_duplicate([[_ | _] | _] = input) do
      heads = Enum.map(input, &hd/1)
      tails = Enum.map(input, &tl/1)

      if Enum.uniq(heads) == [hd(heads)] do
        remove_duplicate(tails)
      else
        [heads | remove_duplicate(tails)]
      end
    end

    defp extract_numbers(operations) do
      Enum.flat_map(operations, fn line ->
        ~r/-?\d+/
        |> Regex.scan(line)
        |> Enum.map(fn [number] -> String.to_integer(number) end)
      end)
    end

    defp add_index({operation, offset1, offset2}, index) do
      {operation, offset1, offset2, index}
    end

    defp order_stack(list), do: order_stack(list, [], [], [])
    defp order_stack([], _, _, acc), do: Enum.reverse(acc)

    defp order_stack([{1, _, _, _} = val | rest], g1, g2, acc) do
      case g2 do
        [g2h | g2t] -> order_stack(rest, g1, g2t, [{val, g2h} | acc])
        [] -> order_stack(rest, [val | g1], g2, acc)
      end
    end

    defp order_stack([{26, _, _, _} = val | rest], g1, g2, acc) do
      case g1 do
        [g1h | g1t] -> order_stack(rest, g1t, g2, [{g1h, val} | acc])
        [] -> order_stack(rest, g1, [val | g2], acc)
      end
    end

    defp find_digit({{1, _, value1, index1}, {26, value2, _, index2}}, :high) do
      difference = value1 + value2

      if difference > 0 do
        [{index1, 9 - difference}, {index2, 9}]
      else
        [{index1, 9}, {index2, 9 + difference}]
      end
    end

    defp find_digit({{1, _, value1, index1}, {26, value2, _, index2}}, :low) do
      difference = value1 + value2

      if difference > 0 do
        [{index1, 1}, {index2, 1 + difference}]
      else
        [{index1, 1 - difference}, {index2, 1}]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_execute(:high)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_execute(:low)
    end
  end
end
