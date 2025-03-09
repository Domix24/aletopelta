defmodule Aletopelta.Year2023.Day11 do
  @moduledoc """
  Day 11 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """
    def parse_input(input) do
      Enum.with_index(input, &parse_line/2)
      |> Enum.flat_map(& &1)
    end

    defp parse_line line, index do
      String.graphemes(line)
      |> Enum.with_index(fn
        "#", column -> {column, index}
        _, _ -> nil
      end) |> Enum.reject(&is_nil/1)
    end

    def expand coords, size do
      columns = do_expand coords, &elem(&1, 0), size
      rows = do_expand coords, &elem(&1, 1), size

      Enum.map coords, fn {x, y} ->
        {Map.fetch!(columns, x), Map.fetch!(rows, y)}
      end
    end

    defp do_expand coords, get_key, size do
      Enum.group_by(coords, &get_key.(&1))
      |> Map.keys
      |> Enum.sort
      |> Enum.reduce({nil, 0, Map.new()}, fn key, {last, increment, acc} ->
        increment = if is_nil(last), do: (key - 0) * (size - 1), else: increment + ((key - last - 1) * (size - 1))
        {key, increment, Map.put_new(acc, key, key + increment)}
      end)
      |> elem(2)
    end

    def build_pairs [] do
      []
    end
    def build_pairs [first | next] do
      Enum.reduce(next, [], fn part, acc ->
        [{first, part} | acc]
      end)
      |> then(fn list ->
        list ++ build_pairs next
      end)
    end

    def build_distance {{x1, y1}, {x2, y2}} do
      abs(x1 - x2) + abs(y1 - y2)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.expand(2)
      |> Common.build_pairs
      |> Enum.map(&Common.build_distance/1)
      |> Enum.sum
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.expand(1_000_000)
      |> Common.build_pairs
      |> Enum.map(&Common.build_distance/1)
      |> Enum.sum
    end
  end
end
