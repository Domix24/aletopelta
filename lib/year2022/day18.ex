defmodule Aletopelta.Year2022.Day18 do
  @moduledoc """
  Day 18 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """
    @spec parse_input(any()) :: list()
    def parse_input(input) do
      Enum.map(input, fn list ->
        [x, y, z] = list
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        {x, y, z}
      end)
    end

    @spec get_directions({number(), number(), number()}) :: list()
    def get_directions({x, y, z}) do
      [{x, y, z + 1},
       {x, y, z - 1},
       {x, y + 1, z},
       {x, y - 1, z},
       {x + 1, y, z},
       {x - 1, y, z}]
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(any()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> surface_area()
    end

    defp surface_area(blocks) do
      blocks_set = MapSet.new(blocks)

      Enum.sum_by(blocks_set, fn position ->
        position
        |> Common.get_directions()
        |> Enum.count(fn position ->
          not MapSet.member?(blocks_set, position)
        end)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(any()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> surface_area()
    end

    defp surface_area(blocks) do
      blocks_set = MapSet.new(blocks)

      {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}} = get_bounds(blocks)
      bounds = {min_x..max_x, min_y..max_y, min_z..max_z}
      start_position = {min_x, min_y, min_z}
      visited = MapSet.new([start_position])

      count_surface([start_position], bounds, blocks_set, visited)
    end

    defp get_bounds(blocks) do
      Enum.reduce(blocks, {{nil, nil}, {nil, nil}, {nil, nil}}, &calculate_bounds/2)
    end

    defp calculate_bounds({x, y, z}, {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}}) do
      {{get_min(min_x, x - 1), get_max(max_x, x + 1)},
       {get_min(min_y, y - 1), get_max(max_y, y + 1)},
       {get_min(min_z, z - 1), get_max(max_z, z + 1)}}
    end

    defp get_min(nil, value), do: value
    defp get_min(value1, value2), do: min(value1, value2)

    defp get_max(nil, value), do: value
    defp get_max(value1, value2), do: max(value1, value2)

    defp count_surface([], _, _, _), do: 0
    defp count_surface(positions, bounds, blocks, visited) do
      {new_positions, faces, new_visited} = Enum.reduce(positions, {[], 0, visited}, fn position, {positions, faces, visited} ->
        adjacents = Common.get_directions(position)

        new_faces = Enum.count(adjacents, &MapSet.member?(blocks, &1)) + faces
        new_adjacents = Enum.filter(adjacents, &valid_adjacent?(&1, bounds, blocks, visited))
        new_visited = Enum.reduce(new_adjacents, visited, &MapSet.put(&2, &1))
        new_positions = new_adjacents ++ positions

        {new_positions, new_faces, new_visited}
      end)

      count_surface(new_positions, bounds, blocks, new_visited) + faces
    end

    defp valid_adjacent?({x, y, z} = pos, {bounds_x, bounds_y, bounds_z}, blocks, visited) do
      x in bounds_x and y in bounds_y and z in bounds_z and !MapSet.member?(blocks, pos) and !MapSet.member?(visited, pos)
    end
  end
end
