defmodule Aletopelta.Day20241212 do
  defmodule Region do
    defstruct [:name, :size, :area]
  end

  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Enum.with_index
      |> Enum.flat_map(fn {line, index} ->
        line
        |> String.graphemes
        |> Enum.with_index(fn grapheme, idx ->
          {{idx, index}, grapheme}
        end)
      end)
      |> Map.new
      |> process_regions
      |> Enum.reduce(0, fn %Region{size: size, area: area}, acc -> acc + size * area end)
    end

    defp process_regions(grid) when map_size(grid) < 1 do
      []
    end
    defp process_regions(grid) do
      {position, letter} = grid
      |> Enum.at(0)

      {region, new_grid} = grid
      |> process_region([position], letter, [])

      [region | process_regions(new_grid)]
    end

    defp process_region(grid, [position | other_positions], letter, visited) do
      sides = position
      |> then(fn {x, y} ->
        [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
        |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      end)
      |> Enum.filter(fn position ->
        value = grid
        |> Map.get(position)

        value == letter and position not in visited
      end)

      total_positions = sides ++ other_positions
      |> Enum.uniq

      process_region(grid, total_positions, letter, [position | visited])
    end
    defp process_region(grid, [], letter, visited) do
      region_area = visited
      |> Enum.count

      region_size = visited
      |> Enum.map(fn {x, y} ->
        [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
        |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
        |> Enum.count(&(&1 not in visited))
      end)
      |> Enum.sum

      new_region = %Region{name: letter, size: region_size, area: region_area}
      new_grid = grid
      |> Map.drop(visited)

      {new_region, new_grid}
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
#dbg(pretty: true, limit: :infinity, charlists: :as_list)
