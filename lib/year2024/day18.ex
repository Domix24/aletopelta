defmodule Aletopelta.Year2024.Day18 do
  @moduledoc """
  Day 18 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """
    def parse_input(input) do
      input
      |> Stream.filter(&(&1 != ""))
      |> Stream.map(&parse_line/1)
    end

    defp parse_line(line) do
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    def create_map(parsed_input) do
      for [x, y] <- parsed_input, into: %{}, do: {{x, y}, :wall}
    end

    def search_path(map_data, {start_point, end_point}, boundary) do
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
        |> Enum.uniq()
        |> Enum.filter(&valid_point?(&1, visited_nodes, map_data, boundary))

      if end_point in valid_neighbors, do: throw({:found, depth})

      updated_visited_nodes = update_visited_nodes(visited_nodes, valid_neighbors)

      search_loop(
        map_data,
        end_point,
        boundary,
        valid_neighbors,
        updated_visited_nodes,
        depth + 1
      )
    end

    defp valid_point?({x, y} = xy, visited_nodes, map_data, boundary) do
      x in boundary and y in boundary and not Map.has_key?(visited_nodes, xy) and
        Map.get(map_data, xy) == nil
    end

    defp neighboring_points({x, y}) do
      [
        {x + 0, y + 1},
        {x + 1, y + 0},
        {x + 0, y - 1},
        {x - 1, y + 0}
      ]
    end

    defp update_visited_nodes(visited_nodes, valid_neighbors) do
      Map.merge(visited_nodes, Map.new(valid_neighbors, fn point -> {point, true} end))
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    def execute(input) do
      boundary = 0..70
      amount_to_take = 1024
      parsed_input = Common.parse_input(input) |> Enum.take(amount_to_take)
      map_data = Common.create_map(parsed_input)
      max_boundary = Enum.max(boundary)

      Common.search_path(map_data, {{0, 0}, {max_boundary, max_boundary}}, boundary)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    def execute(input) do
      boundary = 0..70
      amount_to_take = 1024
      parsed_input = Common.parse_input(input)
      {base, future} = Enum.split(parsed_input, amount_to_take)
      base_map = Common.create_map(base)
      max_boundary = Enum.max(boundary)
      boundary_tuple = {{0, 0}, {max_boundary, max_boundary}}

      future_maps =
        Stream.scan(future, base_map, fn coord, acc ->
          Map.merge(acc, Common.create_map([coord]))
        end)

      future_maps_map = Stream.zip(future, Enum.to_list(future_maps)) |> Enum.into(%{})

      search_fn = fn coord ->
        new_map = Map.get(future_maps_map, coord)

        case Common.search_path(new_map, boundary_tuple, boundary) do
          {:error, _} -> {true, coord}
          _ -> {false, coord}
        end
      end

      try do
        find(length(future), fn index ->
          case search_fn.(Enum.at(future, index)) do
            {true, coord} -> {:lt, coord}
            {false, coord} -> {:gt, coord}
          end
        end)
      catch
        blocking_wall -> Enum.join(blocking_wall, ",")
      end
    end

    defp find(max, comparator) do
      find(0, max, comparator, nil)
    end

    defp find(min, max, _, coord) when max <= min, do: throw(coord)

    defp find(min, max, comparator, _) do
      value = div(min + max, 2)

      case comparator.(value) do
        {:lt, coord} -> find(min, value - 1, comparator, coord)
        {:gt, coord} -> find(value + 1, max, comparator, coord)
      end
    end
  end
end
