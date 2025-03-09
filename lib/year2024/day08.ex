defmodule Aletopelta.Year2024.Day08 do
  @moduledoc """
  Day 8 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """
    def parse_input(input) do
      map = input
      |> Enum.filter(&(&1 != ""))
      |> Enum.with_index(&{&2, &1})
      |> Enum.map(fn cell ->
        elem(cell, 1)
        |> String.graphemes
        |> Enum.with_index(&{&2, elem(cell, 0), &1})
      end)

      map_width = length(Enum.at(map, 0))
      map_height = length(map)

      {map, map_width, map_height}
    end

    def get_antennas(map) do
      map
      |> Enum.flat_map(&(&1))
      |> Enum.filter(&(elem(&1, 2) != "."))
      |> Enum.group_by(&elem(&1, 2), &{elem(&1, 0), elem(&1, 1)})
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    def execute(input) do
      {map, map_width, map_height} = input
      |> Common.parse_input

      map
      |> Common.get_antennas
      |> Enum.map(&{elem(&1, 0), map_distance(elem(&1, 1))})
      |> Enum.flat_map(fn {_, list} ->
        list
        |> Enum.flat_map(&[elem(&1, 0), elem(&1, 3)])
      end)
      |> Enum.uniq
      |> Enum.count(&(elem(&1, 0) > -1 and elem(&1, 0) < map_width and elem(&1, 1) > -1 and elem(&1, 1) < map_height))
    end

    defp map_distance([]), do: []
    defp map_distance([point1 | points]) do
      map_distance(point1, points) ++ map_distance(points)
    end

    defp map_distance({_, _}, []), do: []
    defp map_distance(point1, [point2 | points]) do
      [map_distance(point1, point2) | map_distance(point1, points)]
    end

    defp map_distance({x1, y1}, {x2, y2}) do
      {{x1 + x1 - x2, y1 + y1 - y2}, {x1, y1}, {x2, y2}, {x2 + x2 - x1, y2 + y2 - y1}}
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    def execute(input) do
      {map, map_width, map_height} = input
      |> Common.parse_input

      map
      |> Common.get_antennas
      |> Enum.map(&{elem(&1, 0), map_distance(elem(&1, 1), {map_width, map_height})})
      |> Enum.flat_map(fn {_frequency, list} ->
        list
        |> Enum.flat_map(&[elem(&1, 0), elem(&1, 1) | elem(&1, 2)])
      end)
      |> Enum.uniq
      |> Enum.count
    end

    defp map_distance([point | points], map_size) do
      map_distance(point, points, map_size) ++ map_distance(points, map_size)
    end
    defp map_distance([], _map_size), do: []
    defp map_distance(point1, [point2 | points], map_size) do
      [map_distance(point1, point2, map_size) | map_distance(point1, points, map_size)]
    end
    defp map_distance({x1, y1}, {x2, y2}, {max_x, max_y}) do
      {{x1, y1}, {x2, y2}, fill_antinodes({x1, y1}, {x2, y2}, {x1 - x2, y1 - y2, x2 - x1, y2 - y1}, {max_x, max_y})}
    end
    defp map_distance(_point, [], _map_size), do: []

    defp fill_antinodes({x1, y1}, {x2, y2}, {delta_x_left, delta_y_left, delta_x_right, delta_y_right}, {max_x, max_y}) do
      fill_antinodes({x1, y1}, {delta_x_left, delta_y_left}, {max_x, max_y})
      ++
      fill_antinodes({x2, y2}, {delta_x_right, delta_y_right}, {max_x, max_y})
    end
    defp fill_antinodes({x, y}, {delta_x, delta_y}, {max_x, max_y}) when x + delta_x > -1 and y + delta_y > -1 and x + delta_x < max_x and y + delta_y < max_y do
      [{x + delta_x, y + delta_y} | fill_antinodes({x + delta_x, y + delta_y}, {delta_x, delta_y}, {max_x, max_y})]
    end
    defp fill_antinodes(_point, _delta, _map_size), do: []
  end
end
