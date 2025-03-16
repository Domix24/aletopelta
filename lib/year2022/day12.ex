defmodule Aletopelta.Year2022.Day12 do
  @moduledoc """
  Day 12 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """
    @spec parse_input(list()) :: {any(), any(), any(), any(), any()}
    def parse_input(input) do
      input
      |> Enum.reduce({%{}, nil, nil, 0, 0}, &process_line/2)
      |> then(fn {map, start, target, row, column} ->
        {map, start, target, 0..column, 0..(row - 1)}
      end)
    end

    defp process_line(line, {map, start, target, row, _}) do
      line
      |> String.graphemes()
      |> Enum.reduce({map, start, target, 0, row}, &process_cell/2)
      |> then(fn {map, start, target, column, _} -> {map, start, target, row + 1, column - 1} end)
    end

    defp process_cell(<<sign>>, {map, start, target, column, row}) do
      {new_sign, new_start, new_target} =
        case sign do
          ?S ->
            {?a, {column, row}, target}

          ?E ->
            {?z, start, {column, row}}

          sign ->
            {sign, start, target}
        end

      new_map = Map.put(map, {column, row}, new_sign - ?a)
      {new_map, new_start, new_target, column + 1, row}
    end

    @spec find_shortest({any(), any(), any()}, any(), any()) :: integer()
    def find_shortest({true, _, _}, _, depth) do
      depth
    end

    def find_shortest({_, positions, visited}, {map, _, target, limit_x, limit_y} = info, depth) do
      positions
      |> Enum.reduce_while({false, MapSet.new(), visited}, fn {x, y}, {_, positions, visited} ->
        get_next(
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}],
          {x, y},
          {limit_x, limit_y},
          map,
          target,
          positions,
          visited
        )
      end)
      |> find_shortest(info, depth + 1)
    end

    defp get_next(deltas, {x, y}, {limit_x, limit_y}, map, target, positions, visited) do
      deltas
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> filter_positions(visited, limit_x, limit_y, map, {x, y})
      |> MapSet.new()
      |> merge_positions(target, visited, positions)
    end

    defp filter_positions(positions, visited, limit_x, limit_y, map, {x, y}) do
      Enum.filter(positions, fn position ->
        not MapSet.member?(visited, position) and
          coordinate_valid?(position, limit_x, limit_y) and
          step?(map, {x, y}, position)
      end)
    end

    defp merge_positions(new_positions, target, visited, positions) do
      if MapSet.member?(new_positions, target) do
        {:halt, {true, MapSet.new([target]), MapSet.put(visited, target)}}
      else
        {:cont,
         {false, MapSet.union(positions, new_positions), MapSet.union(visited, new_positions)}}
      end
    end

    defp coordinate_valid?({x, y}, limit_x, limit_y) do
      x in limit_x and y in limit_y
    end

    defp step?(map, current_position, new_position) do
      Map.fetch!(map, new_position) - Map.fetch!(map, current_position) < 2
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> find_shortest()
    end

    defp find_shortest({_, start, _, _, _} = map_info) do
      Common.find_shortest({false, MapSet.new([start]), MapSet.new([start])}, map_info, 0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> find_lowest()
      |> find_shortest()
    end

    defp find_lowest({map, _, _, _, _} = map_info) do
      map
      |> Enum.filter(&(elem(&1, 1) == 0))
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()
      |> then(fn lowest -> {map_info, lowest} end)
    end

    defp find_shortest({map_info, lowest}) do
      Common.find_shortest({false, lowest, lowest}, map_info, 0)
    end
  end
end
