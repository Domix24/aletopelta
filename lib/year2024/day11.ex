defmodule Aletopelta.Year2024.Day11 do
  @moduledoc """
  Day 11 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """
    def parse_input(input, max_blinks) do
      input
      |> Enum.map(&String.split(&1, " "))
      |> Enum.at(0)
      |> start_blink(max_blinks)
      |> Enum.reduce(0, &(elem(&1, 1) + &2))
    end

    defp split_stone(stone) do
      chunk_length = div(String.length(stone), 2)

      {first, second} =
        stone
        |> String.split_at(chunk_length)

      second =
        second
        |> String.trim_leading("0")
        |> then(fn
          "" -> "0"
          anything -> anything
        end)

      [first, second]
    end

    defp start_blink(stones, max_blinks) do
      stones
      |> Enum.map(&{&1, 1})
      |> merge
      |> start_blink(0, max_blinks)
    end

    defp start_blink(stones, blink_index, max_blinks) when max_blinks == blink_index, do: stones

    defp start_blink(stones, blink_index, max_blinks) do
      stones
      |> Enum.map(fn
        {"0", amount} -> {{:ok, "1"}, amount}
        {stone, amount} -> {{rem(String.length(stone), 2) == 0, stone}, amount}
      end)
      |> Enum.flat_map(fn
        {{:ok, stone}, amount} ->
          [{stone, amount}]

        {{true, stone}, amount} ->
          split_stone(stone)
          |> Enum.map(&{&1, amount})

        {{false, stone}, amount} ->
          [{"#{String.to_integer(stone) * 2024}", amount}]
      end)
      |> merge
      |> start_blink(blink_index + 1, max_blinks)
    end

    defp merge(stones) do
      stones
      |> Enum.reduce(%{}, fn {stone, amount}, map ->
        map
        |> Map.update(stone, amount, &(&1 + amount))
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    def execute(input \\ nil) do
      input
      |> Common.parse_input(25)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    def execute(input \\ nil) do
      input
      |> Common.parse_input(75)
    end
  end
end
