defmodule Aletopelta.Year2021.Day09 do
  @moduledoc """
  Day 9 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """
    @spec parse_input([binary()]) :: %{{integer(), integer()} => integer()}
    def parse_input(input) do
      {_, new_acc} =
        Enum.reduce(input, {0, %{}}, fn line, {y, acc} ->
          {_, new_acc} =
            line
            |> String.graphemes()
            |> Enum.reduce({0, acc}, fn cell, {x, acc} ->
              {x + 1, Map.put(acc, {x, y}, String.to_integer(cell))}
            end)

          {y + 1, new_acc}
        end)

      new_acc
    end

    @spec traverse(%{{integer(), integer()} => integer()}) :: [{integer(), integer()}]
    def traverse(map) do
      traverse(map, [{Map.fetch!(map, {0, 0}), {0, 0}}], MapSet.new([{0, 0}]))
    end

    defp traverse(_, [], _), do: []

    defp traverse(map, points, visited) do
      adjacents = Enum.map(points, &get_adjacents(&1, map))
      {lows, _} = Enum.split_with(adjacents, &low?/1)

      new_adjacents = traverse_adjacents(adjacents, visited)
      new_lows = traverse_lows(lows)
      new_visited = traverse_visited(new_adjacents, visited)

      new_lows ++ traverse(map, new_adjacents, new_visited)
    end

    defp traverse_adjacents(adjacents, visited) do
      adjacents
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {_, _, height, position} -> {height, position} end)
      |> Enum.uniq()
      |> Enum.reject(fn {_, position} -> MapSet.member?(visited, position) end)
    end

    defp traverse_lows(lows) do
      lows
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {height, position, _, _} -> {height, position} end)
      |> Enum.uniq()
    end

    defp traverse_visited(adjacents, visited) do
      adjacents
      |> MapSet.new(fn {_, position} -> position end)
      |> MapSet.union(visited)
    end

    defp low?(adjacents) do
      Enum.all?(adjacents, fn {base_height, _, new_height, _} ->
        base_height < new_height
      end)
    end

    @spec get_adjacents({integer(), {integer(), integer()}}, %{
            {integer(), integer()} => integer()
          }) :: [{integer(), integer(), integer(), integer()}]
    def get_adjacents({base_height, {x, y} = base_position}, map) do
      Enum.flat_map([{0, 1}, {0, -1}, {1, 0}, {-1, 0}], fn {dx, dy} ->
        point = {dx + x, dy + y}

        case Map.get(map, point) do
          nil -> []
          height -> [{base_height, base_position, height, point}]
        end
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> Enum.sum_by(&(elem(&1, 0) + 1))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> bassinize()
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.reduce(&(&1 * &2))
    end

    defp bassinize(map) do
      map
      |> Common.traverse()
      |> Enum.map(&bassinize(&1, map))
    end

    defp bassinize(point, map) do
      points = [point]
      result = points ++ bassinize(points, map, :two)

      result
      |> Enum.uniq()
      |> Enum.count()
    end

    defp bassinize([], _, :two), do: []

    defp bassinize(points, map, :two = step) do
      adjacents =
        points
        |> Enum.flat_map(&Common.get_adjacents(&1, map))
        |> Enum.filter(fn {base_height, _, new_height, _} ->
          base_height < new_height and new_height < 9
        end)
        |> Enum.map(fn {_, _, new_height, new_position} ->
          {new_height, new_position}
        end)

      adjacents ++ bassinize(adjacents, map, step)
    end
  end
end
