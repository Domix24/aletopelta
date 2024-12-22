defmodule Aletopelta.Day20241216 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> parse_input
      |> do_tracking
    end

    defp parse_input(input) do
      parse_input(input, 0)
      |> Enum.reduce(%{}, fn {position, value}, acc ->
        Map.put(acc, position, value)
      end)
    end

    defp parse_input([], _) do
      []
    end

    defp parse_input([first | rest], row_index) do
      line = first
      |> parse_line(row_index)

      line ++ parse_input(rest, row_index + 1)
    end

    defp parse_line(line, row_index) do
      line
      |> String.graphemes
      |> Enum.with_index(&{{&2, row_index}, &1})
    end

    defp do_tracking(map) do
      start_position = Enum.find_value(map, fn
        {position, "S"} -> position
        _ -> nil
      end)

      end_position = Enum.find_value(map, fn
        {position, "E"} -> position
        _ -> nil
      end)

      {score, path} = find_path(map, start_position, end_position)
      draw_path(map, path)
      score
    end

    defp find_path(map, start_position, end_position) do
      do_find(map, [{[start_position], 0, :east}], end_position, %{})
    end

    defp do_find(map, [{[current_position | _] = positions, score, direction} | _] = queue, end_position, visited) do
      if current_position == end_position do
        {score, positions}
      else
        sides = get_sides(map, current_position, direction)
        queue = append_sides(sides, queue, visited)
        visited = Map.put(visited, {current_position, direction}, true)

        do_find(map, queue, end_position, visited)
      end
    end

    defp get_sides(map, {px, py}, direction) do
      [ccw(direction), direction, cw(direction)]
      |> Enum.map(fn direction -> {delta(direction), direction} end)
      |> Enum.map(fn {{dx, dy}, direction} -> {{px + dx, py + dy}, direction} end)
      |> Enum.filter(fn {pos, _} -> Map.get(map, pos) != "#" end)
    end

    defp append_sides(sides, [{positions, score, last_direction} | rest], visited) do
      Enum.reduce(sides, rest, fn {position, direction}, acc ->
        score = score + if direction == last_direction, do: 1, else: 1001

        if Map.has_key?(visited, {position, direction}) do
          acc
        else
          [{[position | positions], score, direction} | acc]
        end
      end)
      |> Enum.sort_by(&elem(&1, 1))
    end

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
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
