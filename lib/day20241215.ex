defmodule Aletopelta.Day20241215 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> parse_input
      |> start
      |> calculate_coordinate
    end

    defp calculate_coordinate({map, _}) do
      map
      |> Enum.filter(&(elem(&1, 1) == :object))
      |> Enum.reduce(0, fn {{x, y}, _}, total -> x + 100 * y + total end)
    end

    defp start({map, directions, player}) do
      map
      |> move_player(player, directions)
    end

    defp move_player(map, player, []), do: {map, player}

    defp move_player(map, {px, py} = player, [direction | other_directions]) do
      {map, player} = direction
      |> get_delta
      |> then(fn {dx, dy} = delta -> {{px + dx, py + dy}, delta} end)
      |> then(fn {position, delta} ->
        map
        |> Map.get(position)
        |> then(fn
          :object -> {position, player, delta}
          :empty -> {position}
          _ -> {player}
        end)
      end)
      |> propagate_move(map)

      map
      |> Map.put(player, :empty)
      |> move_player(player, other_directions)
    end

    defp can_push_object?(map, {x, y}, {dx, dy} = delta) do
      new_position = {x + dx, y + dy}

      map
      |> Map.get(new_position)
      |> then(fn
        :wall -> false
        :empty -> [new_position]
        :object ->
          map
          |> can_push_object?(new_position, delta)
          |> then(fn
            false -> false
            positions -> [new_position | positions]
          end)
      end)
    end

    defp push_object(map, []), do: map

    defp push_object(map, [first | rest]) do
      map
      |> Map.put(first, :object)
      |> push_object(rest)
    end

    defp propagate_move({new_position, old_position, delta}, map) do
      map
      |> can_push_object?(new_position, delta)
      |> then(fn
        false -> {map, old_position}
        list ->
          new_map = map
          |> push_object(list)
          {new_map, new_position}
      end)
    end

    defp propagate_move({position}, map), do: {map, position}

    defp get_delta(:north), do: {0, -1}
    defp get_delta(:east), do: {1, 0}
    defp get_delta(:south), do: {0, 1}
    defp get_delta(:west), do: {-1, 0}

    defp parse_input(lines) do
      {parsed_map, parsed_direction} = lines
      |> parse_input(0)
      |> Enum.flat_map(&(&1))
      |> Enum.split_with(fn
        {{_, _}, _} -> true
        _ -> false
      end)

      {parsed_map, parsed_player} = parsed_map
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.reduce({%{}, nil}, fn {position, [value]}, {parsing_map, parsing_player} ->
        {value, parsing_player} = case value do
          :player -> {:empty, position}
          _ -> {value, parsing_player}
        end
        parsing_map = parsing_map
        |> Map.put(position, value)
        {parsing_map, parsing_player}
      end)

      {parsed_map, parsed_direction, parsed_player}
    end

    defp parse_input([], _) do
      []
    end

    defp parse_input([first | lines], row_index) do
      parsed_first = first
      |> String.graphemes
      |> parse_line(row_index)
      |> Enum.filter(&(&1))

      parsed_lines = lines
      |> parse_input(row_index + 1)

      [parsed_first | parsed_lines]
    end

    defp parse_line(graphemes, row_index) do
      graphemes
      |> Enum.with_index(fn
        "#", index -> {{index, row_index}, :wall}
        "@", index -> {{index, row_index}, :player}
        ".", index -> {{index, row_index}, :empty}
        "O", index -> {{index, row_index}, :object}
        "^", _ -> :north
        ">", _ -> :east
        "v", _ -> :south
        "<", _ -> :west
        _, _ -> nil
      end)
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
