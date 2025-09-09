defmodule Aletopelta.Year2019.Day15 do
  @moduledoc """
  Day 15 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type point() :: {integer(), integer()}
    @type grid() :: %{point() => integer()}

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec build_grid(Intcode.intcode()) :: grid()
    def build_grid(intcode) do
      position = {0, 0}
      grid = Map.new([{position, 1}])
      memory = Map.new(program: intcode, index: 0, base: 0)
      direction = 1

      memory
      |> do_grid(direction, grid, position)
      |> Enum.filter(fn {_, obj} -> obj > 0 end)
      |> Map.new()
    end

    defp do_grid(memory, direction, grid, position) do
      {new_memory, [object], _} =
        Intcode.continue(memory, [direction])

      {new_grid, new_position, new_direction} = dispatch(object, grid, position, direction)

      if new_position == {0, 0} do
        new_grid
      else
        do_grid(new_memory, new_direction, new_grid, new_position)
      end
    end

    defp clockwise(1), do: 3
    defp clockwise(3), do: 2
    defp clockwise(2), do: 4
    defp clockwise(4), do: 1

    defp counterclockwise(1), do: 4
    defp counterclockwise(3), do: 1
    defp counterclockwise(2), do: 3
    defp counterclockwise(4), do: 2

    defp update_position({x, y}, 1), do: {x, y + 1}
    defp update_position({x, y}, 2), do: {x, y - 1}
    defp update_position({x, y}, 3), do: {x + 1, y}
    defp update_position({x, y}, 4), do: {x - 1, y}

    defp dispatch(0, grid, position, direction) do
      wall_position = update_position(position, direction)
      new_grid = Map.put(grid, wall_position, 0)

      new_direction =
        Enum.reduce_while(0..2, direction, fn _, acc_direction ->
          new_direction = clockwise(acc_direction)
          new_position = update_position(position, new_direction)

          if Map.get(new_grid, new_position) == 0 do
            {:cont, new_direction}
          else
            {:halt, new_direction}
          end
        end)

      {new_grid, position, new_direction}
    end

    defp dispatch(object, grid, position, direction) when object in [1, 2] do
      new_position = update_position(position, direction)
      new_direction = counterclockwise(direction)
      new_grid = Map.put(grid, new_position, object)

      {new_grid, new_position, new_direction}
    end

    @spec get_nexts(point(), grid(), %{point() => list(point())}) :: list(point())
    def get_nexts({x, y}, grid, graph) do
      [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn point -> Map.get(grid, point, 0) > 0 and Map.get(graph, point) == nil end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_grid()
      |> build_graph()
    end

    defp build_graph(grid) do
      {0, 0}
      |> build_graph(Map.new(), 0, grid)
      |> elem(1)
    end

    defp build_graph(point, graph, depth, grid) do
      nexts = Common.get_nexts(point, grid, graph)

      fulldepth = if Map.get(grid, point) == 2, do: depth, else: nil

      new_graph = Map.put(graph, point, nexts)

      Enum.reduce(nexts, {new_graph, fulldepth}, fn nextpts, {acc_graph, acc_depth} ->
        {new_graph, old_depth} = build_graph(nextpts, acc_graph, depth + 1, grid)

        if old_depth do
          {new_graph, old_depth}
        else
          {new_graph, acc_depth}
        end
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_grid()
      |> build_graph()
    end

    defp build_graph(grid) do
      grid
      |> Enum.find_value(&find_target/1)
      |> build_graph(Map.new(), 0, grid)
      |> elem(1)
    end

    defp find_target({point, 2}), do: point
    defp find_target(_), do: nil

    defp build_graph(point, graph, depth, grid) do
      nexts = Common.get_nexts(point, grid, graph)

      new_graph = Map.put(graph, point, nexts)

      Enum.reduce(nexts, {new_graph, depth}, fn nextpts, {acc_graph, acc_depth} ->
        {new_graph, old_depth} = build_graph(nextpts, acc_graph, depth + 1, grid)

        {new_graph, max(acc_depth, old_depth)}
      end)
    end
  end
end
