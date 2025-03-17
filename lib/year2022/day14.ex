defmodule Aletopelta.Year2022.Day14 do
  @moduledoc """
  Day 14 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """
    @spec parse_input(list()) :: {any(), number()}
    def parse_input(input) do
      input
      |> Enum.flat_map(fn line ->
        line
        |> String.split([" ", "->", ","], trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.chunk_every(2, 1, :discard)
      end)
      |> build_map()
    end

    defp build_map(grid) do
      Enum.reduce(grid, {MapSet.new(), 0}, fn [[from_x, from_y], [to_x, to_y]], {grid, max_y} ->
        range_x = build_range(from_x, to_x)
        range_y = build_range(from_y, to_y)

        new_max = max(max_y, range_y.last)

        new_grid =
          for x <- range_x, y <- range_y, reduce: grid do
            grid -> MapSet.put(grid, {x, y})
          end

        {new_grid, new_max}
      end)
    end

    defp build_range(from, to) do
      from
      |> min(to)
      |> Range.new(max(from, to))
    end

    @spec drop_sand({any(), number()}, boolean()) :: number()
    def drop_sand({grid, max_y}, has_floor) do
      floor_y = max_y + 2

      0
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while({grid, 0}, fn _, {grid, count} ->
        dispatch_drop(
          simulate_sand(grid, {500, 0}, max_y, has_floor, floor_y),
          has_floor,
          count,
          grid,
          floor_y
        )
      end)
    end

    defp dispatch_drop({:abyss, _}, false, count, _, _), do: {:halt, count}
    defp dispatch_drop({:settled, _, {500, 0}}, true, count, _, _), do: {:halt, count + 1}

    defp dispatch_drop({:settled, new_grid, _}, _, count, _, _),
      do: {:cont, {new_grid, count + 1}}

    defp dispatch_drop({:abyss, x}, true, count, grid, floor_y) do
      new_grid = MapSet.put(grid, {x, floor_y - 1})
      {:cont, {new_grid, count + 1}}
    end

    defp simulate_sand(grid, {x, y}, max_y, has_floor, floor_y) do
      {x, y} = move_sand(grid, {x, y}, max_y, has_floor, floor_y)

      if y > max_y and not has_floor do
        {:abyss, x}
      else
        {:settled, MapSet.put(grid, {x, y}), {x, y}}
      end
    end

    defp move_sand(grid, {x, y}, max_y, has_floor, floor_y) do
      {state, value} = move_simple({x, y}, max_y, has_floor, floor_y)

      if state do
        value
      else
        move_advanced(grid, {x, y}, max_y, has_floor, floor_y)
      end
    end

    defp move_simple({x, y}, _, true, floor_y) when y + 1 >= floor_y, do: {true, {x, y}}
    defp move_simple({x, y}, max_y, false, _) when y > max_y, do: {true, {x, y + 1}}
    defp move_simple(_, _, _, _), do: {false, 0}

    defp move_advanced(grid, {x, y}, max_y, has_floor, floor_y) do
      [{0, 1}, {-1, 1}, {1, 1}]
      |> Enum.reduce_while({0, 0}, fn {dx, dy}, _ ->
        new_pos = {x + dx, y + dy}

        if MapSet.member?(grid, new_pos) do
          {:cont, {false, nil}}
        else
          value = move_sand(grid, new_pos, max_y, has_floor, floor_y)
          {:halt, {true, value}}
        end
      end)
      |> then(fn
        {true, value} -> value
        {false, _} -> {x, y}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.drop_sand(false)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.drop_sand(true)
    end
  end
end
