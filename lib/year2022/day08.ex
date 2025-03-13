defmodule Aletopelta.Year2022.Day08 do
  @moduledoc """
  Day 8 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """
    @spec parse_input(any()) :: any()
    def parse_input(input) do
      input
      |> Enum.reduce({%{}, 0}, fn line, {tree_map, row_idx} ->
        {new_map, _} =
          line
          |> String.graphemes()
          |> Enum.map(&String.to_integer/1)
          |> Enum.reduce({tree_map, 0}, fn height, {map, col_idx} ->
            new_map = Map.put(map, {col_idx, row_idx}, height)
            {new_map, col_idx + 1}
          end)

        {new_map, row_idx + 1}
      end)
      |> elem(0)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> count_visible()
    end

    defp count_visible(tree_map) do
      columns = get_columns(tree_map)
      rows = get_rows(tree_map)

      visible_columns = Enum.flat_map(columns, &find_visible/1)
      visible_rows = Enum.flat_map(rows, &find_visible/1)

      (visible_columns ++ visible_rows)
      |> MapSet.new()
      |> MapSet.size()
    end

    defp get_columns(tree_map) do
      tree_map
      |> Enum.group_by(fn {{x, _}, _} -> x end)
      |> Map.values()
      |> Enum.map(fn column -> Enum.sort_by(column, fn {{_, y}, _} -> y end) end)
    end

    defp get_rows(tree_map) do
      tree_map
      |> Enum.group_by(fn {{_, y}, _} -> y end)
      |> Map.values()
      |> Enum.map(fn row -> Enum.sort_by(row, fn {{x, _}, _} -> x end) end)
    end

    defp find_visible(line) do
      {_, max_height} = Enum.max_by(line, fn {_, height} -> height end)

      left_visible = scan_trees(line, max_height)

      right_visible =
        line
        |> Enum.reverse()
        |> scan_trees(max_height)

      (left_visible ++ right_visible)
      |> MapSet.new()
      |> MapSet.to_list()
    end

    defp scan_trees(line, max_height) do
      line
      |> Enum.reduce_while({-1, []}, fn
        {tree, ^max_height}, {_, visible_trees} ->
          {:halt, [tree | visible_trees]}

        {tree, height}, {last_height, visible_trees} when height > last_height ->
          {:cont, {height, [tree | visible_trees]}}

        _, acc ->
          {:cont, acc}
      end)
      |> then(fn
        {_, trees} -> trees
        trees -> trees
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> find_score()
    end

    defp find_score(tree_map) do
      map_bounds = find_boundaries(tree_map)

      tree_map
      |> Enum.group_by(fn {_, height} -> height end, fn {tree, _} -> tree end)
      |> Enum.sort_by(fn {height, _} -> height end, :desc)
      |> Enum.reduce({0, MapSet.new()}, fn {_, trees}, {max_score, checked_trees} ->
        calculate_scores(trees, checked_trees, max_score, map_bounds)
      end)
      |> elem(0)
    end

    defp find_boundaries(tree_map) do
      {min_x, max_x} =
        tree_map
        |> Map.keys()
        |> Enum.map(fn {x, _} -> x end)
        |> Enum.min_max()

      {min_y, max_y} =
        tree_map
        |> Map.keys()
        |> Enum.map(fn {_, y} -> y end)
        |> Enum.min_max()

      {min_x, max_x, min_y, max_y}
    end

    defp calculate_scores(trees, checked_trees, max_score, map_bounds) do
      {min_x, max_x, min_y, max_y} = map_bounds

      blocking_trees =
        trees
        |> MapSet.new()
        |> MapSet.union(checked_trees)

      Enum.reduce(trees, {max_score, blocking_trees}, fn
        {x, y}, {score, checked} when x == min_x or x == max_x or y == min_y or y == max_y ->
          {score, checked}

        tree, {score, checked} ->
          scenic_score =
            tree
            |> calculate_scenic(blocking_trees, map_bounds)
            |> max(score)

          {scenic_score, checked}
      end)
    end

    defp calculate_scenic(tree, blocking_trees, map_bounds) do
      [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
      |> Enum.map(fn delta ->
        count_trees(tree, delta, blocking_trees, map_bounds)
      end)
      |> Enum.reduce(fn count, product -> count * product end)
    end

    defp count_trees({x, y}, {dx, dy}, blocking_positions, map_bounds) do
      {min_x, max_x, min_y, max_y} = map_bounds

      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while(0, fn steps, _ ->
        new_x = x + dx * steps
        new_y = y + dy * steps
        new_pos = {new_x, new_y}

        cond do
          new_x < min_x or new_x > max_x or new_y < min_y or new_y > max_y ->
            {:halt, steps - 1}

          MapSet.member?(blocking_positions, new_pos) ->
            {:halt, steps}

          true ->
            {:cont, steps}
        end
      end)
    end
  end
end
