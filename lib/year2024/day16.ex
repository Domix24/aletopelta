defmodule Aletopelta.Year2024.Day16 do
  @moduledoc """
  Day 16 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """
    defp ccw(:north), do: :west
    defp ccw(:west), do: :south
    defp ccw(:south), do: :east
    defp ccw(:east), do: :north

    defp cw(:north), do: :east
    defp cw(:west), do: :north
    defp cw(:south), do: :west
    defp cw(:east), do: :south

    defp delta(:north), do: {0, -1}
    defp delta(:west), do: {-1, 0}
    defp delta(:south), do: {0, 1}
    defp delta(:east), do: {1, 0}

    def append_sides(sides, [{positions, score, last_direction} | rest], visited) do
      Enum.reduce(sides, rest, fn {position, direction}, acc ->
        score = score + if direction == last_direction, do: 1, else: 1001

        with_direction = Map.has_key?(visited, {position, direction})
        with_opposite = Map.has_key?(visited, {position, cw(cw(direction))})

        cond do
          not with_direction -> [{[position | positions], score, direction} | acc]
          not with_opposite -> [{[position | positions], score, direction} | acc]
          true -> acc
        end
      end)
      |> Enum.sort_by(&elem(&1, 1))
    end

    def get_sides(map, {px, py}, direction) do
      [ccw(direction), direction, cw(direction)]
      |> Enum.map(fn direction -> {delta(direction), direction} end)
      |> Enum.map(fn {{dx, dy}, direction} -> {{px + dx, py + dy}, direction} end)
      |> Enum.filter(fn {pos, _} -> Map.get(map, pos) != "#" end)
    end

    def parse_input(input) do
      parse_input(input, 0)
      |> Enum.reduce(%{}, fn {position, value}, acc ->
        Map.put(acc, position, value)
      end)
    end

    def parse_input([], _) do
      []
    end

    def parse_input([first | rest], row_index) do
      line =
        first
        |> parse_line(row_index)

      line ++ parse_input(rest, row_index + 1)
    end

    defp parse_line(line, row_index) do
      line
      |> String.graphemes()
      |> Enum.with_index(&{{&2, row_index}, &1})
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    def execute(input) do
      input
      |> Common.parse_input()
      |> do_tracking
    end

    defp do_tracking(map) do
      start_position =
        Enum.find_value(map, fn
          {position, "S"} -> position
          _ -> nil
        end)

      end_position =
        Enum.find_value(map, fn
          {position, "E"} -> position
          _ -> nil
        end)

      find_path(map, start_position, end_position)
    end

    defp find_path(map, start_position, end_position) do
      do_find(map, [{[start_position], 0, :east}], end_position, %{})
    end

    defp do_find(
           map,
           [{[current_position | _], score, direction} | _] = queue,
           end_position,
           visited
         ) do
      if current_position == end_position do
        score
      else
        sides = Common.get_sides(map, current_position, direction)
        queue = Common.append_sides(sides, queue, visited)
        visited = Map.put(visited, {current_position, direction}, true)

        do_find(map, queue, end_position, visited)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    def execute(input) do
      input
      |> Common.parse_input()
      |> do_tracking
    end

    defp do_tracking(map) do
      start_position =
        Enum.find_value(map, fn
          {position, "S"} -> position
          _ -> nil
        end)

      end_position =
        Enum.find_value(map, fn
          {position, "E"} -> position
          _ -> nil
        end)

      find_path(map, start_position, end_position)
    end

    defp find_path(map, start_position, end_position) do
      do_find(map, [{[start_position], 0, :east}], end_position, %{})
    end

    defp do_find(
           map,
           [{[current_position | _], score, direction} | _] = queue,
           end_position,
           visited
         ) do
      if current_position == end_position do
        queue =
          queue
          |> Enum.filter(fn
            {[^end_position | _], ^score, _} -> true
            _ -> false
          end)
          |> Enum.flat_map(&elem(&1, 0))
          |> Enum.uniq()

        length(queue)
      else
        sides = Common.get_sides(map, current_position, direction)
        queue = Common.append_sides(sides, queue, visited)
        visited = Map.put(visited, {current_position, direction}, true)

        do_find(map, queue, end_position, visited)
      end
    end
  end
end
