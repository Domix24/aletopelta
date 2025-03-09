defmodule Aletopelta.Year2024.Day06 do
  @moduledoc """
  Day 6 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """
    def parse_input(input), do: parse_input(input, 0)

    def parse_input([], _row_index), do: {[], nil}
    def parse_input([""], _row_index), do: {[], nil}

    def parse_input([first_line | rest], row_index) do
      new_first_line =
        for {char, index} <- String.graphemes(first_line) |> Enum.with_index() do
          {index, row_index, char}
        end

      guard_position =
        new_first_line
        |> Enum.find(fn {_, _, symbol} -> symbol == "^" end)

      {remaining_map, remaining_guard_position} =
        rest
        |> parse_input(row_index + 1)

      full_map = [new_first_line | remaining_map]
      final_guard_position = guard_position || remaining_guard_position

      {full_map, final_guard_position}
    end

    def calculate_next_position(guard_x, guard_y, "^"), do: {guard_x, guard_y - 1}
    def calculate_next_position(guard_x, guard_y, ">"), do: {guard_x + 1, guard_y}
    def calculate_next_position(guard_x, guard_y, "v"), do: {guard_x, guard_y + 1}
    def calculate_next_position(guard_x, guard_y, "<"), do: {guard_x - 1, guard_y}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    def execute(input) do
      {map, guard_position} =
        input
        |> Common.parse_input()

      map
      |> move_guard(guard_position)
      |> Enum.uniq()
      |> Enum.count()
    end

    defp move_guard(map, {guard_x, guard_y, guard_direction}) do
      map_width = length(Enum.at(map, 0))
      map_height = length(map)

      {next_guard_x, next_guard_y} =
        Common.calculate_next_position(guard_x, guard_y, guard_direction)

      case get_symbol(map, next_guard_x, next_guard_y, map_width, map_height) do
        nil -> [{guard_x, guard_y}]
        "#" -> handle_rotation(map, guard_x, guard_y, guard_direction)
        _ -> [{guard_x, guard_y} | move_guard(map, {next_guard_x, next_guard_y, guard_direction})]
      end
    end

    defp get_symbol(_, x, _, _, _) when x < 0, do: nil
    defp get_symbol(_, x, _, width, _) when x + 1 > width, do: nil
    defp get_symbol(_, _, y, _, _) when y < 0, do: nil
    defp get_symbol(_, _, y, _, height) when y + 1 > height, do: nil
    defp get_symbol(map, x, y, _, _), do: elem(Enum.at(Enum.at(map, y), x), 2)

    defp handle_rotation(map, guard_x, guard_y, "^"), do: move_guard(map, {guard_x, guard_y, ">"})
    defp handle_rotation(map, guard_x, guard_y, ">"), do: move_guard(map, {guard_x, guard_y, "v"})
    defp handle_rotation(map, guard_x, guard_y, "v"), do: move_guard(map, {guard_x, guard_y, "<"})
    defp handle_rotation(map, guard_x, guard_y, "<"), do: move_guard(map, {guard_x, guard_y, "^"})
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    def execute(input) do
      {map, guard_position} =
        input
        |> Common.parse_input()

      map
      |> move_guard(guard_position)
    end

    defp move_guard(map, {guard_x, guard_y, guard_direction}) do
      map_width = length(Enum.at(map, 0))
      map_height = length(map)
      initial_position = {guard_x, guard_y}

      map
      |> move(
        {guard_x, guard_y, guard_direction},
        initial_position,
        map_width,
        map_height,
        %{},
        %{},
        nil
      )
    end

    defp move(
           map,
           {guard_x, guard_y, guard_direction},
           initial_position,
           map_width,
           map_height,
           walls,
           blocking_walls,
           loop_wall_position
         ) do
      {next_guard_x, next_guard_y} =
        Common.calculate_next_position(guard_x, guard_y, guard_direction)

      case get_symbol(map, next_guard_x, next_guard_y, map_width, map_height, loop_wall_position) do
        nil ->
          0

        "#" ->
          if Map.has_key?(walls, {next_guard_x, next_guard_y, guard_direction}) do
            1
          else
            new_walls = Map.put(walls, {next_guard_x, next_guard_y, guard_direction}, true)

            handle_rotation(
              map,
              {guard_x, guard_y, guard_direction},
              initial_position,
              map_width,
              map_height,
              new_walls,
              blocking_walls,
              loop_wall_position
            )
          end

        _ ->
          if loop_wall_position == nil and {next_guard_x, next_guard_y} != initial_position and
               not Map.has_key?(blocking_walls, {next_guard_x, next_guard_y}) do
            new_blocking_walls = Map.put(blocking_walls, {next_guard_x, next_guard_y}, true)

            move_with_loop =
              move(
                map,
                {guard_x, guard_y, guard_direction},
                initial_position,
                map_width,
                map_height,
                walls,
                new_blocking_walls,
                {next_guard_x, next_guard_y}
              )

            move_without_loop =
              move(
                map,
                {next_guard_x, next_guard_y, guard_direction},
                initial_position,
                map_width,
                map_height,
                walls,
                new_blocking_walls,
                nil
              )

            move_with_loop + move_without_loop
          else
            map
            |> move(
              {next_guard_x, next_guard_y, guard_direction},
              initial_position,
              map_width,
              map_height,
              walls,
              blocking_walls,
              loop_wall_position
            )
          end
      end
    end

    defp get_symbol(_, x, _, _, _, _) when x < 0, do: nil
    defp get_symbol(_, x, _, width, _, _) when x >= width, do: nil
    defp get_symbol(_, _, y, _, _, _) when y < 0, do: nil
    defp get_symbol(_, _, y, _, height, _) when y >= height, do: nil
    defp get_symbol(_, x, y, _, _, {loop_x, loop_y}) when x == loop_x and y == loop_y, do: "#"
    defp get_symbol(map, x, y, _, _, _), do: elem(Enum.at(Enum.at(map, y), x), 2)

    defp handle_rotation(
           map,
           {guard_x, guard_y, "^"},
           initial_position,
           map_width,
           map_height,
           walls,
           blocking_walls,
           loop_wall_position
         ),
         do:
           move(
             map,
             {guard_x, guard_y, ">"},
             initial_position,
             map_width,
             map_height,
             walls,
             blocking_walls,
             loop_wall_position
           )

    defp handle_rotation(
           map,
           {guard_x, guard_y, ">"},
           initial_position,
           map_width,
           map_height,
           walls,
           blocking_walls,
           loop_wall_position
         ),
         do:
           move(
             map,
             {guard_x, guard_y, "v"},
             initial_position,
             map_width,
             map_height,
             walls,
             blocking_walls,
             loop_wall_position
           )

    defp handle_rotation(
           map,
           {guard_x, guard_y, "v"},
           initial_position,
           map_width,
           map_height,
           walls,
           blocking_walls,
           loop_wall_position
         ),
         do:
           move(
             map,
             {guard_x, guard_y, "<"},
             initial_position,
             map_width,
             map_height,
             walls,
             blocking_walls,
             loop_wall_position
           )

    defp handle_rotation(
           map,
           {guard_x, guard_y, "<"},
           initial_position,
           map_width,
           map_height,
           walls,
           blocking_walls,
           loop_wall_position
         ),
         do:
           move(
             map,
             {guard_x, guard_y, "^"},
             initial_position,
             map_width,
             map_height,
             walls,
             blocking_walls,
             loop_wall_position
           )
  end
end
