defmodule Aletopelta.Day20241210 do
  defmodule Common do
    def parse_input(input) do
      map = input
      |> Enum.filter(&(&1 != ""))
      |> to_number

      map_length = map
      |> length

      map_width = map
      |> Enum.at(0)
      |> length

      {map, map_length, map_width}
    end

    defp to_number([], 1) do
      []
    end
    defp to_number([first_char | other_chars], 1) do
      first_number = first_char
      |> String.to_integer

      other_numbers = other_chars
      |> to_number(1)

      [first_number | other_numbers]
    end
    defp to_number([]) do
      []
    end
    defp to_number([first_line | other_lines]) do
      first_numbers = first_line
      |> String.graphemes
      |> to_number(1)

      other_numbers = other_lines
      |> to_number

      [first_numbers | other_numbers]
    end

    def search_for_zeros([first_line | other_lines]) do
      search_for_zeros([first_line | other_lines], 0)
      |> Enum.flat_map(&(&1))
    end
    def search_for_zeros([], _) do
      []
    end
    def search_for_zeros([first_line | other_lines], row_index) do
      first_zeros = search_for_zeros(first_line, row_index, 0)
      other_zeros = search_for_zeros(other_lines, row_index + 1)

      [first_zeros | other_zeros]
    end
    def search_for_zeros([0 | other_chars], row_index, column_index) do
      [{column_index, row_index, 0} | search_for_zeros(other_chars, row_index, column_index + 1)]
    end
    def search_for_zeros([_ | other_chars], row_index, column_index) do
      search_for_zeros(other_chars, row_index, column_index + 1)
    end
    def search_for_zeros([], _, _) do
      []
    end

    def build_path({_, _, 9} = starting_point, _, _) do
      [[starting_point]]
    end
    def build_path({_x, _y, n} = starting_point, map, map_info) do
      [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
      |> Enum.map(fn delta ->
        next_point = get_next_point(starting_point, delta, map, map_info)
        {delta, next_point}
      end)
      |> Enum.filter(fn
        {_, {_, _, next_n}} -> next_n == n + 1
        _ -> false
      end)
      |> Enum.map(fn {_delta, next_point} ->
        rest_build_path = build_path(next_point, map, map_info)
        |> Enum.flat_map(fn x -> x end)
        [starting_point | rest_build_path]
      end)
    end
    def build_path([], _, _) do
      []
    end
    def build_path([{_x, _y, 0} = starting_point | other_points], map, map_info) do
      [build_path(starting_point, map, map_info) | build_path(other_points, map, map_info)]
    end

    defp get_next_point({x, y, _n}, {dx, dy}, map, {max_x, max_y}) when x + dx > -1 and y + dy > -1 and x + dx < max_x and y + dy < max_y do
      {next_point_x, next_point_y} = {x + dx, y + dy}

      next_point_n = map
      |> Enum.at(next_point_y)
      |> Enum.at(next_point_x)

      {next_point_x, next_point_y, next_point_n}
    end
    defp get_next_point(_, _, _, _) do
      nil
    end
  end

  defmodule Part1 do
    def execute(input \\ nil) do
     {map, map_length, map_width} = input
     |> Common.parse_input

      map_info = {map_length, map_width}

      map
      |> Common.search_for_zeros
      |> Common.build_path(map, map_info)
      |> Enum.map(fn list ->
        list
        |> Enum.flat_map(fn sublist ->
          sublist
          |> Enum.filter(fn
            {_, _, 9} -> true
            _ -> false
          end)
        end)
        |> Enum.uniq
        |> Enum.count
      end)
      |> Enum.sum
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
     {map, map_length, map_width} = input
     |> Common.parse_input

      map_info = {map_length, map_width}

      map
      |> Common.search_for_zeros
      |> Common.build_path(map, map_info)
      |> Enum.map(fn list ->
        list
        |> Enum.map(fn sublist ->
          sublist
          |> Enum.count(fn
            {_, _, 9} -> true
            _ -> false
          end)
        end)
        |> Enum.sum
      end)
      |> Enum.sum
    end
  end
end
