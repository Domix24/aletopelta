defmodule Aletopelta.Year2023.Day16 do
  @moduledoc """
  Day 16 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """
    def parse_input(input) do
      {result, _} = Enum.reduce input, {%{}, 0}, fn list, {acc, row_index} ->
        {acc, _} = String.graphemes(list)
        |> Enum.reduce({acc, 0}, fn key, {acc, column_index} ->
          parse_key key, acc, column_index, row_index
        end)

        {acc, row_index + 1}
      end

      result
    end

    defp parse_key ".", map, column_index, row_index do
      {Map.put(map, {column_index, row_index}, :empty), column_index + 1}
    end
    defp parse_key "|", map, column_index, row_index do
      indications = [
        [from: :north, to: [:north]],
        [from: :east, to: [:north, :south]],
        [from: :south, to: [:south]],
        [from: :west, to: [:north, :south]]]
      {Map.put(map, {column_index, row_index}, {:mirror_ns, indications}), column_index + 1}
    end
    defp parse_key "/", map, column_index, row_index do
      indications = [
        [from: :north, to: [:east]],
        [from: :east, to: [:north]],
        [from: :south, to: [:west]],
        [from: :west, to: [:south]]]
      {Map.put(map, {column_index, row_index}, {:mirror_nesw, indications}), column_index + 1}
    end
    defp parse_key "-", map, column_index, row_index do
      indications = [
        [from: :north, to: [:east, :west]],
        [from: :east, to: [:east]],
        [from: :south, to: [:east, :west]],
        [from: :west, to: [:west]]]
      {Map.put(map, {column_index, row_index}, {:mirror_ew, indications}), column_index + 1}
    end
    defp parse_key "\\", map, column_index, row_index do
      indications = [
        [from: :north, to: [:west]],
        [from: :east, to: [:south]],
        [from: :south, to: [:east]],
        [from: :west, to: [:north]]]
      {Map.put(map, {column_index, row_index}, {:mirror_senw, indications}), column_index + 1}
    end

    def get_delta(:north) do
      {0, -1}
    end
    def get_delta(:east) do
      {1, 0}
    end
    def get_delta(:south) do
      {0, 1}
    end
    def get_delta(:west) do
      {-1, 0}
    end

    def normalize_direction :north do
      0
    end
    def normalize_direction :south do
      0
    end
    def normalize_direction :east do
      1
    end
    def normalize_direction :west do
      1
    end

    def traverse map, {x, y}, direction, visited do
      {dx, dy} = Common.get_delta direction
      position = {x + dx, y + dy}

      cell = Map.fetch map, position

      visited? = Map.fetch(visited, position)
      |> case do
        {:ok, [{other_direction, :empty}]} ->
          Common.normalize_direction(direction) == Common.normalize_direction(other_direction)

        {:ok, [{other_direction, :mirror_nesw}]} ->
          direction == other_direction

        {:ok, [{other_direction, :mirror_senw}]} ->
          direction == other_direction

        {:ok, [{_, :mirror_ew}]} ->
          true

        {:ok, [{_, :mirror_ns}]} ->
          true

#        {:ok, [{_, :empty}, {_, :empty}]} ->
#          true

        {:ok, [_, _]} ->
          true

        :error ->
          false
      end

      cond do
        visited? ->
          visited

        cell == :error ->
          visited

        true ->
          elem(cell, 1)
          |> case do
            :empty ->
              visited = Map.update visited, position, [{direction, :empty}], &[{direction, :empty} | &1]
              traverse map, position, direction, visited

            {mirror, indications} ->
              visited = Map.update visited, position, [{direction, mirror}], &[{direction, mirror} | &1]

              get_indications(indications, direction)
              |> traverse_direction(visited, position, map)
          end
      end
    end

    defp traverse_direction indications, visited, position, map do
      Enum.reduce indications, visited, fn direction, visited ->
        traverse map, position, direction, visited
      end
    end

    defp get_indications indications, direction do
      Enum.find_value indications, nil, fn
        [from: ^direction, to: list] -> list
        _ -> nil
      end
    end

    def _draw_map {input, visited} do
      max_x = (Enum.max_by input, &elem(elem(&1, 0), 0)) |> elem(0) |> elem(0)
      max_y = (Enum.max_by input, &elem(elem(&1, 0), 1)) |> elem(0) |> elem(1)

      IO.puts ""
      for y <- 0..max_y do
        for x <- 0..max_x do
          pos = {x, y}
          (if Map.has_key? visited, {x, y} do
            IO.ANSI.reset <> IO.ANSI.blink_slow
          else
            IO.ANSI.reset <> IO.ANSI.blue_background
          end <> case Map.fetch! input, pos do
            :empty -> "."
            {:mirror_ns, _} -> "|"
            {:mirror_senw, _} -> "\\"
            {:mirror_ew, _} -> "-"
            {:mirror_nesw, _} -> "/"
            :mirror -> "#"
          end)
          |> IO.write
        end
        IO.puts IO.ANSI.reset
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.traverse({-1, 0}, :east, Map.new)
      |> Enum.count
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    def execute(input) do
      Common.parse_input(input)
      |> do_loop
    end

    def do_loop input do
      {min_x, max_x} = Enum.min_max_by input, &elem(elem(&1, 0), 0)
      {min_y, max_y} = Enum.min_max_by input, &elem(elem(&1, 0), 1)

      {min_x, max_x} = {elem(elem(min_x, 0), 0), elem(elem(max_x, 0), 0)}
      {min_y, max_y} = {elem(elem(min_y, 0), 1), elem(elem(max_y, 0), 1)}

      all_positions = for x <- 0..max_x, reduce: [] do
        acc -> [{{x, min_y - 1}, :south}, {{x, max_y + 1}, :north} | acc]
      end
      all_positions = for y <- 0..max_y, reduce: all_positions do
        acc -> [{{min_x - 1, y}, :east}, {{max_x + 1, y}, :west} | acc]
      end

      Enum.reduce all_positions, 0, fn {position, direction}, acc ->
        Common.traverse(input, position, direction, Map.new)
        |> Enum.count
        |> max(acc)
      end
    end
  end
end
