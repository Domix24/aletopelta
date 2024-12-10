defmodule Aletopelta.Day20241206 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      {map, guard_position} = input
      |> parse_input

      map
      |> move_guard(guard_position)
      |> Enum.uniq
      |> Enum.count
    end

    defp parse_input(input, row_index \\ 0)
    defp parse_input([], _), do: {[], nil}
    defp parse_input([first_line | rest], row_index) do
      new_first_line = first_line
      |> String.graphemes
      |> Enum.with_index(fn char, index -> {index, row_index, char} end)

      guard_position = new_first_line
      |> Enum.find(fn {_, _, symbol} -> symbol == "^" end)

      {remaining_map, remaining_guard_position} = parse_input(rest, row_index + 1)

      full_map = [new_first_line | remaining_map]
      final_guard_position = guard_position || remaining_guard_position

      {full_map, final_guard_position}
    end

    defp move_guard(map, {guard_x, guard_y, guard_direction}) do
      map_width = length(Enum.at(map, 0))
      map_height = length(map)

      {next_guard_x, next_guard_y} = calculate_next_position(guard_x, guard_y, guard_direction)

      case get_symbol(map, next_guard_x, next_guard_y, map_width, map_height) do
        nil -> [{guard_x, guard_y}]
        "#" -> handle_rotation(map, guard_x, guard_y, guard_direction)
        _ -> [{guard_x, guard_y} | move_guard(map, {next_guard_x, next_guard_y, guard_direction})]
      end
    end

    defp calculate_next_position(guard_x, guard_y, "^"), do: {guard_x, guard_y - 1}
    defp calculate_next_position(guard_x, guard_y, ">"), do: {guard_x + 1, guard_y}
    defp calculate_next_position(guard_x, guard_y, "v"), do: {guard_x, guard_y + 1}
    defp calculate_next_position(guard_x, guard_y, "<"), do: {guard_x - 1, guard_y}

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
    def execute(_input \\ nil), do: 2
  end
end
