defmodule Aletopelta.Year2024.Day15 do
  @moduledoc """
  Day 15 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """
    defp build_map(map_data) do
      Enum.reduce(map_data, %{}, fn {coordinate, value}, acc ->
        Map.put(acc, coordinate, (value == :player && :empty) || value)
      end)
    end

    defp find_player_position(map_data) do
      Enum.find_value(map_data, fn
        {coordinate, :player} -> coordinate
        _ -> nil
      end)
    end

    def parse_input(lines, func) do
      parsed_data = Enum.with_index(lines) |> Enum.flat_map(&parse_line(&1, func))

      {map_data, directions} =
        Enum.split_with(parsed_data, fn
          {{_, _}, _} -> true
          _ -> false
        end)

      map = build_map(map_data)
      {map, directions, find_player_position(map_data)}
    end

    defp parse_line({line, row_index}, func) do
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(&map_character(&1, row_index, func))
      |> Enum.reject(&is_nil/1)
    end

    defp map_character({"#", index}, row_index, _), do: {{index, row_index}, :wall}
    defp map_character({"@", index}, row_index, _), do: {{index, row_index}, :player}
    defp map_character({".", index}, row_index, _), do: {{index, row_index}, :empty}

    defp map_character({"^", _}, _, _), do: :north
    defp map_character({">", _}, _, _), do: :east
    defp map_character({"v", _}, _, _), do: :south
    defp map_character({"<", _}, _, _), do: :west

    defp map_character(grapheme, index, func), do: func.(grapheme, index)

    def calculate_coordinate({map, _}, objectype) do
      map
      |> Enum.filter(&(elem(&1, 1) == objectype))
      |> Enum.reduce(0, fn {{x, y}, _}, total -> x + 100 * y + total end)
    end

    def get_delta(:north), do: {0, -1}
    def get_delta(:east), do: {1, 0}
    def get_delta(:south), do: {0, 1}
    def get_delta(:west), do: {-1, 0}

    def initiate_simulation({map, directions, player}, func) do
      move_player(map, player, directions, func)
    end

    defp move_player(map, player, [], _), do: {map, player}

    defp move_player(map, player, [direction | other_directions], func) do
      {new_position, updated_map} = func.(map, player, direction)

      updated_map
      |> Map.put(new_position, :empty)
      |> move_player(new_position, other_directions, func)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    def execute(input) do
      input
      |> Common.parse_input(&map_character/2)
      |> Common.initiate_simulation(&process_movement/3)
      |> Common.calculate_coordinate(:object)
    end

    defp map_character({"O", index}, row_index), do: {{index, row_index}, :object}

    defp process_movement(map, {px, py} = player, direction) do
      {dx, dy} = Common.get_delta(direction)
      new_position = {px + dx, py + dy}

      case Map.get(map, new_position) do
        :object ->
          if can_push_objects?(map, new_position, {dx, dy}) do
            updated_map = push_objects(map, new_position, {dx, dy}, [])

            {new_position, updated_map}
          else
            {player, map}
          end

        :empty ->
          {new_position, map}

        _ ->
          {player, map}
      end
    end

    defp can_push_objects?(map, {x, y}, {dx, dy} = delta) do
      new_position = {x + dx, y + dy}

      case Map.get(map, new_position) do
        :wall -> false
        :empty -> true
        :object -> can_push_objects?(map, new_position, delta)
        _ -> false
      end
    end

    defp push_objects(map, {x, y} = position, {dx, dy} = delta, positions) do
      new_position = {x + dx, y + dy}

      case Map.get(map, new_position) do
        :object ->
          push_objects(map, new_position, delta, [position | positions])

        :empty ->
          Enum.reduce(positions, map, fn pos, acc -> Map.put(acc, pos, :object) end)
          |> Map.put(new_position, :object)

        _ ->
          map
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    def execute(input) do
      input
      |> scale_input
      |> Common.parse_input(&map_character/2)
      |> Common.initiate_simulation(&process_movement/3)
      |> Common.calculate_coordinate(:leftobject)
    end

    defp map_character({"[", index}, row_index), do: {{index, row_index}, :leftobject}
    defp map_character({"]", index}, row_index), do: {{index, row_index}, :rightobject}

    defp process_movement(map, {px, py} = player, direction) do
      {dx, dy} = delta = Common.get_delta(direction)
      new_position = {px + dx, py + dy}

      case Map.get(map, new_position) do
        x when x in [:leftobject, :rightobject] ->
          object_list = build_object_list(map, new_position, delta)

          if can_move?(object_list) do
            {new_position, push_objects(map, object_list, delta)}
          else
            {player, map}
          end

        :wall ->
          {player, map}

        :empty ->
          {new_position, map}
      end
    end

    defp build_object_list(map, position, delta) do
      case Map.get(map, position) do
        :leftobject ->
          build_object_entries(map, position, delta, :east, :leftobject, :rightobject)

        :rightobject ->
          build_object_entries(map, position, delta, :west, :rightobject, :leftobject)

        :wall ->
          [{position, :wall}]

        _ ->
          []
      end
    end

    defp build_object_entries(
           map,
           {x, y} = position,
           {dx, dy} = delta,
           direction,
           primary_type,
           secondary_type
         ) do
      {ddx, ddy} = Common.get_delta(direction)
      adjacent_position = {x + ddx, y + ddy}
      new_primary_position = {x + dx, y + dy}
      new_adjacent_position = {x + ddx + dx, y + ddy + dy}

      entries = [{position, primary_type}, {adjacent_position, secondary_type}]

      case delta do
        {0, _} ->
          entries ++
            build_object_list(map, new_primary_position, delta) ++
            build_object_list(map, new_adjacent_position, delta)

        {_, 0} ->
          entries ++
            build_object_list(map, new_primary_position, delta)
      end
    end

    defp can_move?(object_list) do
      Enum.any?(object_list, &(elem(&1, 1) == :wall)) == false
    end

    defp push_objects(map, objects, {dx, dy}) do
      {emptied_map, new_positions} =
        objects
        |> Enum.reduce({map, []}, fn {{old_x, old_y}, type}, {acc_map, acc_positions} ->
          new_position = {old_x + dx, old_y + dy}
          {Map.put(acc_map, {old_x, old_y}, :empty), [{new_position, type} | acc_positions]}
        end)

      Enum.reduce(new_positions, emptied_map, fn {new_position, type}, acc_map ->
        Map.put(acc_map, new_position, type)
      end)
    end

    defp scale_input(lines) do
      lines |> Enum.map(&scale_line(&1))
    end

    defp scale_line(line) do
      line
      |> String.graphemes()
      |> Enum.map_join(&scale_character(&1))
    end

    defp scale_character("#"), do: ["#", "#"]
    defp scale_character("O"), do: ["[", "]"]
    defp scale_character("."), do: [".", "."]
    defp scale_character("@"), do: ["@", "."]
    defp scale_character(cha), do: [cha]
  end
end
