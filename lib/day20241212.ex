defmodule Aletopelta.Day20241212 do
  defmodule Region do
    defstruct [:name, :size, :area, :side]
  end

  defmodule Common do
    def parse_input(input) do
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
      |> calculate_area
    end
    defp process_regions(grid) when map_size(grid) < 1 do
      []
    end
    defp process_regions(grid) do
      {position, letter} = grid
      |> Enum.at(0)

      {region, new_grid, visited} = grid
      |> process_region([position], letter, [])

      [{region, visited} | process_regions(new_grid)]
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
      new_region = %Region{name: letter}
      new_grid = grid
      |> Map.drop(visited)

      {new_region, new_grid, visited}
    end

    defp calculate_area(list) do
      list
      |> Enum.map(fn {region, visited} ->
        region_area = visited
        |> Enum.count
        {%Region{name: region.name, area: region_area}, visited}
      end)
    end
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> calculate_size
      |> Enum.reduce(0, fn %Region{size: size, area: area}, acc -> acc + size * area end)
    end

    defp calculate_size(list) do
      list
      |> Enum.map(fn {region, visited} ->
        region_size = visited
        |> Enum.map(fn {x, y} ->
          [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
          |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
          |> Enum.count(&(&1 not in visited))
        end)
        |> Enum.sum

        %Region{name: region.name, area: region.area, size: region_size}
      end)
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> calculate_side
      |> Enum.reduce(0, fn %Region{side: side, area: area}, acc -> acc + side * area end)
    end

    def calculate_side([]) do
      []
    end
    def calculate_side([{region, visited} | others]) do
      [calculate_side(region, visited) | calculate_side(others)]
    end
    def calculate_side(region, visited) do
      side = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
      |> Enum.map(fn delta ->
        visited
        |> Enum.map(&poke_wall(&1, visited, delta))
        |> Enum.uniq
        |> combine_walls(delta)
      end)
      |> Enum.sum
      %Region{name: region.name, area: region.area, side: side}
    end

    def poke_wall({x, y}, points, {dx, dy} = delta) do
      {x + dx, y + dy}
      |> then(&{&1 in points, &1})
      |> then(fn
        {true, xy} -> poke_wall(xy, points, delta)
        {_, xy} -> xy
      end)
    end

    def combine_walls(walls, {_, 0}) do
      walls
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.map(&Enum.sort(elem(&1, 1)))
      |> Enum.flat_map(&combine_wall(&1))
      |> Enum.count
    end
    def combine_walls(walls, {0, _}) do
      walls
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Enum.map(&Enum.sort(elem(&1, 1)))
      |> Enum.flat_map(&combine_wall(&1))
      |> Enum.count
    end

    def combine_wall([first, second | others]) when abs(second - first) < 2 do
      combine_wall([second | others])
    end
    def combine_wall([wall]) do
      [wall]
    end
    def combine_wall([first | others]) do
     [first | combine_wall(others)]
    end
  end
end
