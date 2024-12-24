defmodule Aletopelta.Day20241218 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil, amount_to_take \\ 1024, boundary \\ 0..70) do
     parsed_input = parse_input(input) |> Enum.take(amount_to_take)
     map_data = create_map(parsed_input)
     max_boundary = Enum.max(boundary)

     search_path(map_data, {{0, 0}, {max_boundary, max_boundary}}, boundary)
    end

    defp parse_input(input) do
      input
      |> Stream.filter(&(&1 != ""))
      |> Stream.map(&parse_line/1)
    end

    defp parse_line(line) do
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    defp create_map(parsed_input) do
      for [x, y] <- parsed_input, into: %{}, do: {{x, y}, :wall}
    end

    defp search_path(map_data, {start_point, end_point}, boundary) do
      initial_queue = [start_point]
      visited_nodes = %{start_point => true}

      search_loop(map_data, end_point, boundary, initial_queue, visited_nodes, 1)
    catch
      {:found, depth} -> depth
    end

    defp search_loop(_, _, _, [], _, _), do: {:error, 0}

    defp search_loop(map_data, end_point, boundary, queue, visited_nodes, depth) do
      valid_neighbors =
        queue
        |> Enum.flat_map(&neighboring_points/1)
        |> Enum.uniq
        |> Enum.filter(&valid_point?(&1, visited_nodes, map_data, boundary))

      if end_point in valid_neighbors, do: throw {:found, depth}

      updated_visited_nodes = update_visited_nodes(visited_nodes, valid_neighbors)
      search_loop(map_data, end_point, boundary, valid_neighbors, updated_visited_nodes, depth + 1)
    end

    defp valid_point?({x, y} = xy, visited_nodes, map_data, boundary) do
      x in boundary and y in boundary and not Map.has_key?(visited_nodes, xy) and Map.get(map_data, xy) == nil
    end

    defp neighboring_points({x, y}) do
      [
        {x + 0, y + 1},
        {x + 1, y + 0},
        {x + 0, y - 1},
        {x - 1, y + 0},
      ]
    end

    defp update_visited_nodes(visited_nodes, valid_neighbors) do
      Map.merge(visited_nodes, Map.new(valid_neighbors, fn point -> {point, true} end))
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
