defmodule Aletopelta.Year2022.Day15 do
  @moduledoc """
  Day 15 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """
    @spec parse_input(list()) :: list()
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r/[\-0-9]+/
        |> Regex.scan(line)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> then(fn [sx, sy, bx, by] ->
          {{sx, sy}, {bx, by}, abs(bx - sx) + abs(by - sy)}
        end)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(list()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> count_beacons(2_000_000)
      |> calculate_positions()
    end

    defp count_beacons(input, target) do
      input
      |> Enum.map(fn {_, beacon, _} -> beacon end)
      |> Enum.filter(fn {_, y} -> y == target end)
      |> MapSet.new()
      |> MapSet.size()
      |> then(fn count -> {input, count, target} end)
    end

    defp calculate_positions({input, count, target}) do
      input
      |> Enum.map(&get_range(&1, target))
      |> Enum.reject(&is_nil/1)
      |> Enum.sort_by(fn {start_x, _} -> start_x end)
      |> Enum.reduce([], &merge_range/2)
      |> Enum.sum_by(fn {start_x, end_x} -> end_x - start_x + 1 end)
      |> then(fn ranges -> ranges - count end)
    end

    defp merge_range(range, []), do: [range]

    defp merge_range({start_x, end_x}, [{prev_start, prev_end} | rest])
         when start_x <= prev_end + 1,
         do: [{prev_start, max(prev_end, end_x)} | rest]

    defp merge_range({start_x, end_x}, [{prev_start, prev_end} | rest]),
      do: [{start_x, end_x}, {prev_start, prev_end} | rest]

    defp get_range({{sx, sy}, _, distance}, target) do
      offset = abs(sy - target)
      remain = distance - offset

      if remain > -1 do
        {sx - remain, sx + remain}
      else
        nil
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(list()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> find_beacon(4_000_000)
    end

    defp find_beacon(sensors, max_coord) do
      sensors
      |> Enum.flat_map(&create_lines/1)
      |> Enum.reduce({[], []}, &split_lines/2)
      |> find_intersections()
      |> Enum.uniq()
      |> Enum.filter(&in_bounds?(&1, max_coord))
      |> Enum.find(&check_point(&1, sensors))
      |> then(fn {x, y} -> x * 4_000_000 + y end)
    end

    defp create_lines({{sx, sy}, _, distance}) do
      perimeter_distance = distance + 1

      [
        {:pos, sy - sx + perimeter_distance},
        {:pos, sy - sx - perimeter_distance},
        {:neg, sy + sx + perimeter_distance},
        {:neg, sy + sx - perimeter_distance}
      ]
    end

    defp split_lines({:pos, b}, {pos, neg}), do: {[b | pos], neg}
    defp split_lines({:neg, b}, {pos, neg}), do: {pos, [b | neg]}

    defp find_intersections({pos_lines, neg_lines}) do
      for p <- pos_lines, n <- neg_lines do
        x = div(n - p, 2)
        y = div(n + p, 2)
        {x, y}
      end
    end

    defp in_bounds?({x, y}, max_coord) do
      x >= 0 and y >= 0 and x <= max_coord and y <= max_coord
    end

    defp check_point({x, y}, sensors) do
      Enum.all?(sensors, fn {{sx, sy}, _, distance} ->
        abs(x - sx) + abs(y - sy) > distance
      end)
    end
  end
end
