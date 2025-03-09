defmodule Aletopelta.Year2023.Day14 do
  @moduledoc """
  Day 14 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """
    def parse_input(input) do
      nb_lines = Enum.count(input)

      Enum.with_index(input, fn line, line_index ->
        String.graphemes(line)
        |> Enum.with_index(fn sign, sign_index ->
          {{sign_index, nb_lines - line_index}, sign}
        end)
      end)
      |> Enum.flat_map(& &1)
    end

    def prepare_input(input) do
      {rocks, blocking_rocks, empty_spaces, [min_x, max_x], [min_y, max_y]} =
        Enum.reduce(input, {[], MapSet.new(), MapSet.new(), [nil, nil], [nil, nil]}, fn {{x, y} =
                                                                                           k,
                                                                                         value},
                                                                                        {rocks1,
                                                                                         rocks2,
                                                                                         spaces,
                                                                                         [
                                                                                           bound0,
                                                                                           bound2
                                                                                         ],
                                                                                         [
                                                                                           bound1,
                                                                                           bound3
                                                                                         ]} ->
          rocks1 = if value == "O", do: [k | rocks1], else: rocks1
          rocks2 = if value == "#", do: MapSet.put(rocks2, k), else: rocks2
          spaces = if value == ".", do: MapSet.put(spaces, k), else: spaces

          bound0 =
            cond do
              bound0 == nil -> x - 1
              bound0 >= x -> x - 1
              true -> bound0
            end

          bound1 =
            cond do
              bound1 == nil -> y - 1
              bound1 >= y -> y - 1
              true -> bound1
            end

          bound2 =
            cond do
              bound2 == nil -> x + 1
              bound2 <= x -> x + 1
              true -> bound2
            end

          bound3 =
            cond do
              bound3 == nil -> y + 1
              bound3 <= y -> y + 1
              true -> bound3
            end

          {rocks1, rocks2, spaces, [bound0, bound2], [bound1, bound3]}
        end)

      calculate_bitmap = fn {x, y} -> 2 ** ((y - 1) * max_x + x) end

      bitmap = Enum.sum_by(rocks, fn pos -> calculate_bitmap.(pos) end)

      {rocks, blocking_rocks, empty_spaces,
       {MapSet.new([min_x, max_x]), MapSet.new([min_y, max_y])}, {bitmap, calculate_bitmap}}
    end

    def get_pressure(input) do
      Enum.sum_by(elem(input, 0), &elem(&1, 1))
    end

    defp get_delta(:north), do: {0, 1}
    defp get_delta(:west), do: {-1, 0}
    defp get_delta(:south), do: {0, -1}
    defp get_delta(:east), do: {1, 0}

    def move(
          {[], blocking_rocks, empty_spaces, invalid_spaces, {_, total_rocks}, bitmap_info},
          _
        ),
        do: {total_rocks, blocking_rocks, empty_spaces, invalid_spaces, bitmap_info}

    def move(
          {[rock | rocks], blocking_rocks, empty_spaces, invalid_spaces,
           {visited_rocks, total_rocks} = visited_spaces,
           {bitmap, calculate_bitmap} = bitmap_info},
          direction
        ) do
      {dx, dy} = delta = get_delta(direction)

      if MapSet.member?(visited_rocks, rock) do
        move(
          {rocks, blocking_rocks, empty_spaces, invalid_spaces, visited_spaces, bitmap_info},
          direction
        )
      else
        {visited_rocks, slide_rocks, _, slide_count} =
          get_slide(
            rock,
            {-dx, -dy},
            {blocking_rocks, empty_spaces, invalid_spaces, visited_rocks},
            MapSet.new([rock]),
            1
          )

        {visited_rocks, slide_rocks, limit, slide_count} =
          get_slide(
            rock,
            delta,
            {blocking_rocks, empty_spaces, invalid_spaces, visited_rocks},
            slide_rocks,
            slide_count
          )

        visited_rocks = MapSet.put(visited_rocks, rock)

        {_, empty_spaces, _, total_rocks, bitmap} =
          for _ <- 1..slide_count,
              reduce: {limit, empty_spaces, slide_rocks, total_rocks, bitmap} do
            {{x, y}, empty_spaces, slide_rocks, total_rocks, bitmap} ->
              {x, y} = {x - dx, y - dy}

              if MapSet.member?(slide_rocks, {x, y}) do
                slide_rocks = MapSet.delete(slide_rocks, {x, y})
                total_rocks = [{x, y} | total_rocks]

                {{x, y}, empty_spaces, slide_rocks, total_rocks, bitmap}
              else
                rock = Enum.at(slide_rocks, 0)

                slide_rocks = MapSet.delete(slide_rocks, rock)
                empty_spaces = MapSet.put(empty_spaces, rock)
                empty_spaces = MapSet.delete(empty_spaces, {x, y})
                total_rocks = [{x, y} | total_rocks]

                bitmap = bitmap - calculate_bitmap.(rock) + calculate_bitmap.({x, y})

                {{x, y}, empty_spaces, slide_rocks, total_rocks, bitmap}
              end
          end

        move(
          {rocks, blocking_rocks, empty_spaces, invalid_spaces, {visited_rocks, total_rocks},
           {bitmap, calculate_bitmap}},
          direction
        )
      end
    end

    defp get_slide(
           {x, y},
           {dx, dy},
           {blocking_rocks, empty_spaces, {invalid_horizontal, invalid_vertical} = invalid_spaces,
            visited_rocks},
           result,
           count
         ) do
      {nx, ny} = {x + dx, y + dy}

      cond do
        MapSet.member?(invalid_horizontal, nx) ->
          {visited_rocks, result, {nx, ny}, count}

        MapSet.member?(invalid_vertical, ny) ->
          {visited_rocks, result, {nx, ny}, count}

        MapSet.member?(blocking_rocks, {nx, ny}) ->
          {visited_rocks, result, {nx, ny}, count}

        MapSet.member?(empty_spaces, {nx, ny}) ->
          get_slide(
            {nx, ny},
            {dx, dy},
            {blocking_rocks, empty_spaces, invalid_spaces, visited_rocks},
            result,
            count
          )

        true ->
          visited_rocks = MapSet.put(visited_rocks, {nx, ny})
          result = MapSet.put(result, {nx, ny})

          get_slide(
            {nx, ny},
            {dx, dy},
            {blocking_rocks, empty_spaces, invalid_spaces, visited_rocks},
            result,
            count + 1
          )
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.prepare_input()
      |> then(fn {rocks, blocking_rocks, empty_spaces, invalid_spaces, bitmap} ->
        {rocks, blocking_rocks, empty_spaces, invalid_spaces, {MapSet.new(), []}, bitmap}
      end)
      |> Common.move(:north)
      |> Common.get_pressure()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.prepare_input()
      |> do_cycle(0, 1_000_000_000)
      |> Common.get_pressure()
    end

    defp do_cycle(input, index, max, visited \\ %{})

    defp do_cycle(input, max, max, _) do
      input
    end

    defp do_cycle(input, index, max, visited) do
      bitmap = elem(elem(input, 4), 0)

      case Map.fetch(visited, bitmap) do
        :error ->
          visited = Map.put(visited, bitmap, index)

          Enum.reduce([:north, :west, :south, :east], input, fn direction,
                                                                {rocks, blocking_rocks,
                                                                 empty_spaces, invalid_spaces,
                                                                 bitmap} ->
            Common.move(
              {rocks, blocking_rocks, empty_spaces, invalid_spaces, {MapSet.new(), []}, bitmap},
              direction
            )
          end)
          |> do_cycle(index + 1, max, visited)

        {:ok, cycle} ->
          size = index - cycle
          offset = max - index
          remain = rem(offset, size)

          if remain == 0 do
            do_cycle(input, max, max)
          else
            step = div(offset, size)
            do_cycle(input, size * step + index, max)
          end
      end
    end
  end
end
