defmodule Aletopelta.Year2023.Day21 do
  @moduledoc """
  Day 21 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """
    def parse_input(input) do
      Enum.reduce(input, {{0, 0}, 0, %{}}, fn line, {starting_position, row_index, map} ->
        String.graphemes(line)
        |> Enum.reduce({starting_position, 0, map}, fn
          "S", {_, column_index, map} ->
            {{column_index, row_index}, column_index + 1, Map.put(map, {column_index, row_index}, :garden)}

          "#", {starting_position, column_index, map} ->
            {starting_position, column_index + 1, map}

          ".", {starting_position, column_index, map} ->
            {starting_position, column_index + 1, Map.put(map, {column_index, row_index}, :garden)}
        end)
        |> then(fn {starting_position, _, map} ->
          {starting_position, row_index + 1, map}
        end)
      end)
    end

    defp process_neighbors {x, y}, steps, queue, visited, map do
      [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
      |> Enum.reduce({queue, visited}, fn {dx, dy}, {queue, visited} ->
        neighbor = {x + dx, y + dy}

        if Map.has_key?(map, neighbor) and !MapSet.member?(visited, neighbor) do
          queue = :queue.in({neighbor, steps + 1}, queue)
          visited = MapSet.put visited, neighbor

          {queue, visited}
        else
          {queue, visited}
        end
      end)
    end

    defp traverse queue, visited, map, max_steps, even_positions, odd_positions do
      case :queue.out queue do
        {:empty, _} ->
          {even_positions, odd_positions}

        {{:value, {pos, steps}}, queue} ->
          if steps > max_steps do
            traverse queue, visited, map, max_steps, even_positions, odd_positions
          else
            {even_positions, odd_positions} = split_oddsevens even_positions, odd_positions, steps, pos

            {queue, visited} = process_neighbors pos, steps, queue, visited, map
            traverse queue, visited, map, max_steps, even_positions, odd_positions
          end
      end
    end

    defp split_oddsevens even_positions, odd_positions, steps, pos do
      if rem(steps, 2) == 0 do
        {Map.put(even_positions, pos, steps), odd_positions}
      else
        {even_positions, Map.put(odd_positions, pos, steps)}
      end
    end

    def traverse start, map, max_steps do
      even_positions = Map.new
      odd_positions = Map.new

      queue = :queue.from_list [{start, 0}]
      visited = MapSet.new [start]

      traverse queue, visited, map, max_steps, even_positions, odd_positions
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    def execute(input) do
      {start, _, map} = Common.parse_input input

      Common.traverse(start, map, 64)
      |> then(&elem &1, 0)
      |> Enum.count
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    def execute(input) do
      {start, size, map} = Common.parse_input(input)

      center_distance = div(size, 2)
      nb_grid = div(26_501_365 - center_distance, size)

      {evens, odds} = Common.traverse start, map, nil

      nb_odds = (nb_grid + 1) ** 2
      nb_evens = (nb_grid) ** 2

      odd_corners = Map.values(odds)
      |> Enum.count(& &1 > center_distance)
      even_corners = Map.values(evens)
      |> Enum.count(& &1 > center_distance)

      result = Map.values(odds) |> Enum.count
      final_result = nb_odds * result

      result = Map.values(evens) |> Enum.count
      result = nb_evens * result
      final_result = final_result + result

      final_result - (nb_grid + 1) * odd_corners + nb_grid * even_corners
    end
  end
end
