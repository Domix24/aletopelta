defmodule Aletopelta.Day20241208 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
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

      antennas = map
      |> Enum.flat_map(&(&1))
      |> Enum.filter(&(elem(&1, 2) != "."))
      |> Enum.group_by(&elem(&1, 2), &{elem(&1, 0), elem(&1, 1)})

      antinodes = antennas
      |> Enum.map(&{elem(&1, 0), map_distance(elem(&1, 1))})
      |> Enum.flat_map(fn {_, list} ->
        list
        |> Enum.flat_map(&[elem(&1, 0), elem(&1, 3)])
      end)
      |> Enum.uniq
      |> Enum.filter(&(elem(&1, 0) > -1 and elem(&1, 0) < map_width and elem(&1, 1) > -1 and elem(&1, 1) < map_height))
      |> Enum.count
    end

    defp map_distance([]), do: []
    defp map_distance([point1 | points]) do
      map_distance(point1, points) ++ map_distance(points)
    end

    defp map_distance({_, _}, []), do: []
    defp map_distance(point1, [point2 | points]) do
      [map_distance(point1, point2) | map_distance(point1, points)]
    end

    defp map_distance({x1, y1}, {x2, y2}), do: {{x1 + x1 - x2, y1 + y1 - y2}, {x1, y1}, {x2, y2}, {x2 + x2 - x1, y2 + y2 - y1}}
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
