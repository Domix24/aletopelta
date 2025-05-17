defmodule Aletopelta.Year2022.Day22 do
  @moduledoc """
  Day 22 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """
    @spec parse_input(list(binary())) :: {map(), {integer(), integer()}, list()}
    def parse_input(input) do
      input
      |> Enum.reduce({0, %{}, nil, :map}, fn
        line, {row_index, map, start_point, :map} ->
          if String.trim(line) == "" do
            {map, start_point, :directions}
          else
            parse_row(line, map, row_index, start_point)
          end

        line, {map, start_point, :directions} ->
          parse_direction(line, map, start_point)

        "", {_, _, _, :end} = acc ->
          acc
      end)
      |> then(fn {map, start_point, directions, _} ->
        {map, start_point, directions}
      end)
    end

    defp parse_row(line, map, row_index, start_point) do
      line
      |> String.trim_trailing()
      |> String.graphemes()
      |> Enum.with_index(&{{&2, row_index}, &1})
      |> Enum.reject(&(elem(&1, 1) == " "))
      |> then(fn list ->
        new_start = find_startpoint(list, start_point)

        new_map =
          list
          |> Map.new()
          |> Map.merge(map)

        {row_index + 1, new_map, new_start, :map}
      end)
    end

    defp parse_direction(line, map, start_point) do
      ~r/([0-9]+)|([RL])/
      |> Regex.scan(line)
      |> Enum.map(fn
        ["L" | _] -> :L
        ["R" | _] -> :R
        [number | _] -> String.to_integer(number)
      end)
      |> then(&{map, start_point, &1, :end})
    end

    defp find_startpoint([{point, "."} | _], nil), do: point
    defp find_startpoint([_ | others], nil), do: find_startpoint(others, nil)
    defp find_startpoint(_, point), do: point

    @spec solve({any(), any(), [:L | :R | integer()], map()}) :: number()
    def solve({map, start_point, directions, adjency}) do
      {{x, y}, facing} = solve(directions, start_point, {1, 0}, map, adjency)

      {nx, ny} = {x + 1, y + 1}
      number = get_rotation(facing)

      ny * 1000 + 4 * nx + number
    end

    defp get_rotation({1, 0}), do: 0
    defp get_rotation({0, 1}), do: 1
    defp get_rotation({-1, 0}), do: 2
    defp get_rotation({0, -1}), do: 3

    defp solve([], point, facing, _, _), do: {point, facing}

    defp solve([current | others], point, facing, map, adjency) when is_integer(current) do
      {new_point, new_facing} =
        Enum.reduce_while(1..current, {point, facing}, fn _, {position, facing} = current_info ->
          process_solve(
            wrap_move(map, position, facing, adjency),
            current_info
          )
        end)

      solve(others, new_point, new_facing, map, adjency)
    end

    defp solve([:R | others], point, {1, 0}, map, adjency),
      do: solve(others, point, {0, 1}, map, adjency)

    defp solve([:R | others], point, {0, 1}, map, adjency),
      do: solve(others, point, {-1, 0}, map, adjency)

    defp solve([:R | others], point, {-1, 0}, map, adjency),
      do: solve(others, point, {0, -1}, map, adjency)

    defp solve([:R | others], point, {0, -1}, map, adjency),
      do: solve(others, point, {1, 0}, map, adjency)

    defp solve([:L | others], point, {1, 0}, map, adjency),
      do: solve(others, point, {0, -1}, map, adjency)

    defp solve([:L | others], point, {0, 1}, map, adjency),
      do: solve(others, point, {1, 0}, map, adjency)

    defp solve([:L | others], point, {-1, 0}, map, adjency),
      do: solve(others, point, {0, 1}, map, adjency)

    defp solve([:L | others], point, {0, -1}, map, adjency),
      do: solve(others, point, {-1, 0}, map, adjency)

    defp wrap_move(map, {x, y} = position, {fx, fy} = facing, adjency) do
      new_position = {x + fx, y + fy}

      case Map.fetch(map, new_position) do
        {:ok, "."} ->
          {new_position, facing}

        {:ok, "#"} ->
          :wall

        :error ->
          {{wpx, wpy}, {wfx, wfy} = wrap_facing} = Map.fetch!(adjency, {position, facing})
          wrap_position = {wpx - wfx, wpy - wfy}

          wrap_move(map, wrap_position, wrap_facing, adjency)
      end
    end

    defp process_solve(:wall, last_info), do: {:halt, last_info}
    defp process_solve(new_info, _), do: {:cont, new_info}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> generate_adjency()
      |> Common.solve()
    end

    defp generate_adjency({map, start, directions}) do
      vlimits = get_limits(map, :vertical)
      hlimits = get_limits(map, :horizontal)

      adjency =
        vlimits
        |> Enum.concat(hlimits)
        |> Map.new()

      {map, start, directions, adjency}
    end

    defp get_limits(map, :vertical) do
      map
      |> Enum.group_by(fn {{x, _}, _} -> x end, fn {{_, y}, _} -> y end)
      |> Enum.flat_map(fn {x, list} ->
        {min, max} = Enum.min_max(list)
        [{{{x, min}, {0, -1}}, {{x, max}, {0, -1}}}, {{{x, max}, {0, 1}}, {{x, min}, {0, 1}}}]
      end)
    end

    defp get_limits(map, :horizontal) do
      map
      |> Enum.group_by(fn {{_, y}, _} -> y end, fn {{x, _}, _} -> x end)
      |> Enum.flat_map(fn {y, list} ->
        {min, max} = Enum.min_max(list)
        [{{{min, y}, {-1, 0}}, {{max, y}, {-1, 0}}}, {{{max, y}, {1, 0}}, {{min, y}, {1, 0}}}]
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> get_size()
      |> generate_adjency()
      |> Common.solve()
    end

    defp generate_adjency({map, start, directions, size}) do
      adjency =
        map
        |> find_corners()
        |> build_adjency(map, size)

      {map, start, directions, adjency}
    end

    defp get_size({map, start, directions}) do
      size =
        map
        |> Enum.group_by(fn {{x, _}, _} -> x end, fn {{_, y}, _} -> y end)
        |> Map.values()
        |> Enum.map(fn list ->
          {min, max} = Enum.min_max(list)
          Range.size(min..max)
        end)
        |> Enum.min()

      {map, start, directions, size}
    end

    defp find_corners(map) do
      map
      |> Stream.map(fn {{x, y}, _} -> {x, y} end)
      |> Stream.filter(&corner?(map, &1))
      |> Enum.to_list()
    end

    defp corner?(map, position) do
      all_directions?(map, position) and diagonal?(map, position)
    end

    defp all_directions?(map, {x, y}) do
      Enum.all?(0..3, fn dir ->
        {dx, dy} = direction(dir)
        Map.has_key?(map, {x + dx, y + dy})
      end)
    end

    defp diagonal?(map, {x, y}) do
      diagonal_present =
        for dir <- 0..3 do
          {dx, dy} = diagonal(dir)
          Map.has_key?(map, {x + dx, y + dy})
        end

      Enum.count(diagonal_present, & &1) == 3
    end

    defp build_adjency(corners, map, size) do
      corners
      |> analyse_initial(map, size)
      |> walk_corners()
    end

    defp analyse_initial(corners, map, size) do
      new_corners =
        Enum.flat_map(corners, fn position ->
          diagonal_direction = find_missing(map, position)

          [0, 1]
          |> Stream.map(fn increment ->
            exit_direction = rotate(diagonal_direction, increment)
            build_corner(map, position, exit_direction, exit_direction, size)
          end)
          |> Stream.reject(&is_nil/1)
          |> Enum.to_list()
        end)

      new_adjency = append_adjency(new_corners, Map.new())
      {new_corners, new_adjency, map, size}
    end

    defp find_missing(map, {x, y}) do
      Enum.find(0..3, fn direction ->
        {dx, dy} = diagonal(direction)
        not Map.has_key?(map, {x + dx, y + dy})
      end)
    end

    defp build_corner(map, {x, y}, exit_direction, last_direction, size) do
      entry_direction = rotate(exit_direction, 2)

      {dx, dy} = direction(exit_direction)
      {nx, ny} = next_position = {x + dx, y + dy}

      Enum.reduce_while([-1, 1], nil, fn amount, _ ->
        direction = rotate(exit_direction, amount)
        {dx, dy} = direction(direction)
        position = {nx + dx, ny + dy}

        if Map.has_key?(map, position) do
          {:cont, nil}
        else
          inner_direction = rotate(direction, 2)

          {:halt,
           {next_position, {last_direction, exit_direction}, entry_direction, inner_direction,
            direction, size}}
        end
      end)
    end

    defp walk_corners({corners, adjency, map, size}),
      do: walk_corners(corners, map, adjency, size)

    defp walk_corners([], _, adjency, _), do: adjency

    defp walk_corners(corners, map, adjency, size) do
      new_corners =
        corners
        |> Stream.flat_map(&follow_path(map, &1, size))
        |> Stream.chunk_every(2)
        |> Stream.filter(fn
          [{_, {dir0, dir1}, _, _, _, _}, {_, {dir2, dir3}, _, _, _, _}] ->
            dir0 == dir1 or dir2 == dir3
        end)
        |> Stream.flat_map(& &1)
        |> Enum.reject(fn
          {position, _, _, _, outer, _} -> Map.has_key?(adjency, {position, direction(outer)})
        end)

      new_adjency = append_adjency(new_corners, adjency)
      walk_corners(new_corners, map, new_adjency, size)
    end

    defp append_adjency(corners, adjency) do
      corners
      |> Stream.chunk_every(2)
      |> Enum.reduce(adjency, fn [
                                   {position0, _, _, inner0, outer0, _},
                                   {position1, _, _, inner1, outer1, _}
                                 ],
                                 acc ->
        acc
        |> Map.put({position0, direction(outer0)}, {position1, direction(inner1)})
        |> Map.put({position1, direction(outer1)}, {position0, direction(inner0)})
      end)
    end

    defp follow_path(
           map,
           {{x, y}, {exit_direction, _}, entry_direction, inner_direction, outer_direction, 1} =
             info,
           size
         ) do
      {dx, dy} = direction(exit_direction)
      next_position = {x + dx, y + dy}

      if Map.has_key?(map, next_position) do
        [
          {next_position, {exit_direction, exit_direction}, entry_direction, inner_direction,
           outer_direction, size}
        ]
      else
        handle_space(map, info, size)
      end
    end

    defp follow_path(
           _,
           {{x, y}, {exit_direction, _}, entry_direction, inner_direction, outer_direction,
            count},
           _
         ) do
      {dx, dy} = direction(exit_direction)
      next_position = {x + dx, y + dy}

      [
        {next_position, {exit_direction, exit_direction}, entry_direction, inner_direction,
         outer_direction, count - 1}
      ]
    end

    defp handle_space(
           map,
           {{x, y} = position, {exit_direction, _}, _, inner_direction, outer_direction, _},
           size
         ) do
      [-1, 1]
      |> Enum.map(fn increment ->
        direction = rotate(exit_direction, increment)
        {dx, dy} = direction(direction)
        new_position = {x + dx, y + dy}

        Map.new()
        |> Map.put(:state, Map.has_key?(map, new_position))
        |> Map.put(:direction, direction)
        |> Map.put(:step, increment)
      end)
      |> process_results({inner_direction, outer_direction, size, position, exit_direction})
    end

    defp process_results([%{state: true} = value, %{state: false}], additionals),
      do: process_results(value, additionals, :step2)

    defp process_results([%{state: false}, %{state: true} = value], additionals),
      do: process_results(value, additionals, :step2)

    defp process_results(_, _), do: []

    defp process_results(
           %{direction: direction, step: step},
           {inner_direction, outer_direction, size, position, old_direction},
           :step2
         ) do
      new_entry = rotate(direction, 2)
      new_inner = rotate(inner_direction, step)
      new_outer = rotate(outer_direction, step)

      [{position, {direction, old_direction}, new_entry, new_inner, new_outer, size}]
    end

    defp rotate(direction, amount), do: rem(direction + amount + 4, 4)

    defp direction(0), do: {1, 0}
    defp direction(1), do: {0, 1}
    defp direction(2), do: {-1, 0}
    defp direction(3), do: {0, -1}

    defp diagonal(0), do: {1, 1}
    defp diagonal(1), do: {-1, 1}
    defp diagonal(2), do: {-1, -1}
    defp diagonal(3), do: {1, -1}
  end
end
