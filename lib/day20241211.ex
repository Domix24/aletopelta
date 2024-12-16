defmodule Aletopelta.Day20241211 do
  defmodule Common do
  end

  defmodule Part1 do
    @max_blinks 25
    def execute(input \\ nil) do
      input
      |> parse_input
      |> start_blinking
      |> Enum.count
    end

    defp parse_input(input) do
      input
      |> Enum.map(&String.split(&1, " "))
      |> Enum.at(0)
    end

    defp start_blinking(stones), do: start_blinking(stones, 0)
    defp start_blinking(stones, @max_blinks), do: stones
    defp start_blinking(stones, blink_index) do
      stones
      |> Enum.map(fn
        "0" -> {:ok, "1"}
        stone -> {rem(String.length(stone), 2) == 0, stone}
      end)
      |> Enum.flat_map(fn
        {:ok, value} -> [value]
        {true, value} -> split_stone_in_two(value)
        {_, value} -> ["#{String.to_integer(value) * 2024}"]
      end)
      |> start_blinking(blink_index + 1)
    end

    defp split_stone_in_two(stone) do
      chunk_length = div(String.length(stone), 2)

      {first, second} = stone
      |> String.split_at(chunk_length)

      second = second
      |> String.trim_leading("0")
      |> then(fn
        "" -> "0"
        anything -> anything
      end)

      [first, second]
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
