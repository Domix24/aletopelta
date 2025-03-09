defmodule Aletopelta.Year2023.Day23 do
  @moduledoc """
  Day 23 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """
    def parse_input(input) do
      {map, _} = Enum.reduce(input, {Map.new, 0}, fn line, {map, row} ->
        {map, _} = String.graphemes(line)
        |> Enum.reduce({map, 0}, fn symbol, {map, column} ->
          symbol = convert_symbol(symbol)

          {Map.put(map, {column, row}, symbol), column + 1}
        end)

        {map, row + 1}
      end)

      map
    end

    defp convert_symbol("."), do: :empty
    defp convert_symbol("#"), do: :wall
    defp convert_symbol("<"), do: {:slope, :west}
    defp convert_symbol(">"), do: {:slope, :east}
    defp convert_symbol("v"), do: {:slope, :south}
    defp convert_symbol("^"), do: {:slope, :north}

    def find_endpoints grid do
      {{min_y, min_tiles}, {max_y, max_tiles}} = Enum.group_by(grid, fn
        {{_, y}, _} -> y end, fn {{x, _}, type} -> {x, type}
      end)
      |> Enum.min_max_by(fn {y, _} -> y end)

      start_pos = Enum.find_value min_tiles, fn
        {x, :empty} -> {x, min_y}
        _ -> false
      end
      end_pos = Enum.find_value max_tiles, fn
        {x, :empty} -> {x, max_y}
        _ -> false
      end

      {start_pos, end_pos}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    def execute(input) do
      grid = Common.parse_input(input)
      {start_pos, end_pos} = Common.find_endpoints grid

      {max_length, _} = trace_path grid, start_pos, end_pos, MapSet.new([start_pos])
      max_length
    end

    defp trace_path _, pos, pos, _ do
      {0, true}
    end
    defp trace_path grid, current_pos, end_pos, visited do
      get_moves(grid, current_pos, visited)
      |> Enum.map(fn pos ->
        visited = MapSet.put visited, pos
        {length, reached} = trace_path grid, pos, end_pos, visited
        {length + 1, reached}
      end)
      |> Enum.reject(fn {_, reached} -> !reached end)
      |> Enum.max_by(fn {length, _} -> length end, fn -> {-1, false} end)
    end

    defp get_moves grid, {x, y} = pos, visited do
      Map.fetch!(grid, pos)
      |> case do
        :empty -> [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
        {:slope, :east} -> [{1, 0}]
        {:slope, :west} -> [{-1, 0}]
        {:slope, :north} -> [{0, -1}]
        {:slope, :south} -> [{0, 1}]
        _ -> []
      end
      |> Enum.reduce([], fn {dx, dy}, acc ->
        pos = {x + dx, y + dy}
        Map.fetch(grid, pos)
        |> case do
          :error ->
            acc

          {:ok, :wall} ->
            acc

          {:ok, _} ->
            construct_moves acc, visited, pos
        end
      end)
    end

    defp construct_moves moves, visited, position do
      if MapSet.member?(visited, position) do
        moves
      else
        [position | moves]
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    def execute(input) do
      grid = Common.parse_input(input)
      |> replace_slope
      |> Map.new
      {start_pos, end_pos} = Common.find_endpoints grid

      build_graph(grid, start_pos, end_pos)
      |> trace_path(start_pos, end_pos, MapSet.new([start_pos]))
    end

    defp trace_path _, pos, pos, _ do
      0
    end
    defp trace_path graph, current_pos, end_pos, visited do
      Map.get(graph, current_pos, [])
      |> Enum.filter(fn {pos, _} -> !MapSet.member? visited, pos end)
      |> case do
        [] ->
          :invalid

        connections ->
          Enum.map(connections, fn {next, distance} ->
            trace_path(graph, next, end_pos, MapSet.put(visited, next))
            |> dispatch_trace(distance)
          end)
          |> Enum.max
      end
    end

    defp dispatch_trace :invalid, _ do
      0
    end
    defp dispatch_trace trace, distance do
      trace + distance
    end

    defp build_graph grid, start_pos, end_pos do
      walkable = Enum.filter(grid, & elem(&1, 1) == :empty)
      |> Enum.map(&elem &1, 0)
      |> MapSet.new

      positions = find_positions walkable, start_pos, end_pos

      Enum.map(positions, fn pos ->
        {pos, map_connections(walkable, pos, positions)}
      end)
      |> Map.new
    end

    defp map_connections walkable, pos, positions do
      queue = :queue.in({pos, 0}, :queue.new)
      search_connections walkable, positions, queue, MapSet.new([pos]), []
    end

    defp search_connections walkable, positions, queue, visited, connections do
      case :queue.out queue do
        {:empty, _} ->
          connections

        {{:value, {pos, distance}}, queue} ->
          if distance > 0 and MapSet.member?(positions, pos) do
            connections = [{pos, distance} | connections]
            search_connections walkable, positions, queue, visited, connections
          else
            nexts = get_next walkable, pos, visited

            queue = build_queue nexts, queue, (distance + 1)
            visited = build_visited nexts, visited

            search_connections walkable, positions, queue, visited, connections
          end
      end
    end

    defp build_queue nexts, queue, distance do
      Enum.reduce nexts, queue, fn next, queue ->
        :queue.in {next, distance}, queue
      end
    end

    defp build_visited nexts, visited do
      Enum.reduce nexts, visited, fn next, visited ->
        MapSet.put visited, next
      end
    end

    defp get_next walkable, {x, y}, visited do
      [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn pos ->
        MapSet.member?(walkable, pos) and !MapSet.member?(visited, pos)
      end)
    end

    defp find_positions walkable, start_pos, end_pos do
      Enum.filter(walkable, fn pos ->
        nexts = count_next walkable, pos
        nexts > 2 or nexts == 1
      end)
      |> MapSet.new
      |> MapSet.union(MapSet.new [start_pos, end_pos])
    end

    defp count_next walkable, {x, y} do
      [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]
      |> Enum.count(fn {dx, dy} ->
        MapSet.member? walkable, {x + dx, y + dy}
      end)
    end

    defp replace_slope input do
      Enum.map(input, fn
        {pos, {:slope, _}} -> {pos, :empty}
        input -> input
      end)
    end
  end
end
