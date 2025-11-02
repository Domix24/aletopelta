defmodule Aletopelta.Year2018.Day22 do
  @moduledoc """
  Day 22 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())
    @type cave() :: %{depth: depth(), target: target(), cells: cells(), east: 0, south: 0}
    @type depth() :: integer()
    @type target() :: %{x: integer(), y: integer()}
    @type cells() :: %{
            {integer(), integer()} => %{geologic: atom(), erosion: atom(), type: atom()}
          }

    @spec parse_input(input()) :: %{depth: depth(), target: target()}
    def parse_input(input) do
      [depth, target_x, target_y] =
        input
        |> Enum.flat_map(fn line ->
          ~r"\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(& &1)
        end)
        |> Enum.map(&String.to_integer/1)

      %{depth: depth, target: %{x: target_x, y: target_y}}
    end

    @spec new_cave(integer(), %{x: integer(), y: integer()}) :: cave()
    def new_cave(depth, target) do
      cave = %{depth: depth, target: target, cells: %{}, east: 0, south: 0}
      explore_location(cave, {0, 0})
    end

    defp explore_location(cave, location) do
      cell =
        %{geologic: nil, erosion: nil, type: nil}
        |> geologic(location, cave)
        |> erosion(cave.depth)
        |> type()

      %{cave | cells: Map.put(cave.cells, location, cell)}
    end

    defp geologic(cell, {0, 0}, _), do: %{cell | geologic: 0}
    defp geologic(cell, {0, v}, _), do: %{cell | geologic: v * 48_271}
    defp geologic(cell, {v, 0}, _), do: %{cell | geologic: v * 16_807}
    defp geologic(cell, {x, y}, %{target: %{x: x, y: y}}), do: %{cell | geologic: 0}

    defp geologic(cell, {x, y}, %{cells: cells}) do
      %{erosion: west_erosion} = Map.fetch!(cells, {x - 1, y})
      %{erosion: north_erosion} = Map.fetch!(cells, {x, y - 1})

      %{cell | geologic: west_erosion * north_erosion}
    end

    defp erosion(cell, depth), do: %{cell | erosion: rem(cell.geologic + depth, 20_183)}

    defp type(cell) do
      type =
        case rem(cell.erosion, 3) do
          0 -> :rocky
          1 -> :wet
          2 -> :narrow
        end

      %{cell | type: type}
    end

    @spec expand_position(cave(), target()) :: cave()
    def expand_position(cave, %{x: _, y: _} = target) do
      cave
      |> Stream.iterate(&expand_west/1)
      |> Enum.at(target.x)
      |> Stream.iterate(&expand_south/1)
      |> Enum.at(target.y)
    end

    @spec expand_position(cave(), {integer(), integer()}) :: cave()
    def expand_position(cave, {x, y}), do: expand_position(cave, %{x: x, y: y})

    defp expand_west(cave) do
      0..cave.south
      |> Enum.reduce(cave, &explore_location(&2, {cave.east + 1, &1}))
      |> Map.update!(:east, &(&1 + 1))
    end

    defp expand_south(cave) do
      0..cave.east
      |> Enum.reduce(cave, &explore_location(&2, {&1, cave.south + 1}))
      |> Map.update!(:south, &(&1 + 1))
    end

    @spec expand_cave(depth(), target()) :: cave()
    def expand_cave(depth, target) do
      max_x = target.x + 50
      max_y = target.y

      depth
      |> new_cave(target)
      |> expand_position({max_x, max_y})
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_part()
    end

    defp do_part(input) do
      input.depth
      |> Common.new_cave(input.target)
      |> Common.expand_position(input.target)
      |> Map.fetch!(:cells)
      |> Enum.sum_by(&risk/1)
    end

    defp risk({_, %{type: type}}), do: risk(type)
    defp risk(:rocky), do: 0
    defp risk(:wet), do: 1
    defp risk(:narrow), do: 2
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_part()
    end

    defp do_part(input) do
      cave = Common.expand_cave(input.depth, input.target)
      target = {input.target.x, input.target.y}

      dijkstra(cave, target)
    end

    defp dijkstra(cave, target) do
      start = {{0, 0}, :torch}
      goal = {target, :torch}

      queue = :gb_trees.insert(0, [start], :gb_trees.empty())
      visited = MapSet.new()

      dijkstra_loop(queue, visited, goal, cave)
    end

    defp dijkstra_loop(queue, visited, goal, cave) do
      case :gb_trees.is_empty(queue) do
        true -> :infinity
        false -> do_loop(queue, visited, goal, cave)
      end
    catch
      {:found, time} -> time
    end

    defp do_loop(queue, visited, goal, cave) do
      {time, positions, queue} = :gb_trees.take_smallest(queue)

      {new_queue, new_visited} =
        Enum.reduce(positions, {queue, visited}, &reduce_positions(&1, &2, goal, time, cave))

      dijkstra_loop(new_queue, new_visited, goal, cave)
    end

    defp reduce_positions(position, {queue, visited} = accumulator, goal, time, cave) do
      if MapSet.member?(visited, position) do
        accumulator
      else
        if position == goal do
          throw({:found, time})
        else
          new_visited = MapSet.put(visited, position)
          new_queue = expand_dijkstra(position, time, cave, new_visited, queue)
          {new_queue, new_visited}
        end
      end
    end

    defp expand_dijkstra({{x, y} = position, tool}, time, cave, visited, queue) do
      [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
      |> Enum.filter(&valid?(&1, cave.cells))
      |> Enum.reduce(queue, &reduce_positions(&1, &2, position, cave, visited, tool, time))
    end

    defp reduce_positions(position, queue, initial, cave, visited, tool, time) do
      current_tools = tools(cave.cells[initial].type)
      next_tools = tools(cave.cells[position].type)

      Enum.reduce(
        current_tools,
        queue,
        &reduce_tools(&1, &2, next_tools, position, visited, tool, time)
      )
    end

    defp reduce_tools(current, queue, tools, position, visited, tool, time) do
      if current in tools do
        new_state = {position, current}

        if MapSet.member?(visited, new_state) === false do
          time
          |> add_time(current, tool)
          |> add_queue(queue, new_state)
        else
          queue
        end
      else
        queue
      end
    end

    defp add_time(time, tool, tool), do: time + 1
    defp add_time(time, _, _), do: time + 8

    defp add_queue(time, queue, state) do
      if :gb_trees.is_defined(time, queue) do
        :gb_trees.enter(time, [state | :gb_trees.get(time, queue)], queue)
      else
        :gb_trees.enter(time, [state], queue)
      end
    end

    defp valid?({v, _}, _) when v < 0, do: false
    defp valid?({_, v}, _) when v < 0, do: false
    defp valid?(position, cells), do: Map.has_key?(cells, position)

    defp tools(:rocky), do: [:climbing_gear, :torch]
    defp tools(:wet), do: [:climbing_gear, :neither]
    defp tools(:narrow), do: [:torch, :neither]
  end
end
