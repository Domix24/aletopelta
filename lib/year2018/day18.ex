defmodule Aletopelta.Year2018.Day18 do
  @moduledoc """
  Day 18 of Year 2018
  """

  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())

    @open 0
    @tree 1
    @lumberyard 2

    @spec parse_input(input()) :: {binary(), %{integer() => list(integer)}, integer(), integer()}
    def parse_input(input) do
      width = height = 50

      grid =
        input
        |> Enum.flat_map(fn line ->
          line
          |> String.graphemes()
          |> Enum.map(&convert_symbol/1)
        end)
        |> :erlang.list_to_binary()

      adjacency =
        width
        |> build_adjacency(height)
        |> Enum.with_index(&{&2, &1})
        |> Map.new()

      {grid, adjacency, width, height}
    end

    defp build_adjacency(width, height) do
      for y <- 0..(height - 1), x <- 0..(width - 1) do
        build_line(x, y, width, height)
      end
    end

    defp build_line(x, y, width, height) do
      for dy <- -1..1,
          dx <- -1..1,
          !(dx == 0 and dy == 0),
          new_y = y + dy,
          new_x = x + dx,
          new_y >= 0,
          new_y < height,
          new_x >= 0,
          new_x < width do
        new_y * width + new_x
      end
    end

    defp convert_symbol("."), do: @open
    defp convert_symbol("|"), do: @tree
    defp convert_symbol("#"), do: @lumberyard

    @spec do_part({binary(), %{integer() => list(integer)}, integer(), integer()}) ::
            Enumerable.t()
    def do_part({grid, adjacency, width, height}),
      do: Stream.iterate({grid, adjacency, width, height, 0, 0}, &next_state/1)

    defp next_state({grid, adjacency, width, height, _, _}) do
      size = width * height

      {new_cells, trees, lumbers} = iterate_cells(0, size, grid, adjacency, [], 0, 0)

      new_grid =
        new_cells
        |> Enum.reverse()
        |> :erlang.list_to_binary()

      {new_grid, adjacency, width, height, trees, lumbers}
    end

    defp iterate_cells(index, index, _, _, cells, trees, lumbers), do: {cells, trees, lumbers}

    defp iterate_cells(index, size, grid, adjacency, cells, trees, lumbers) do
      type = :binary.at(grid, index)
      indices = Map.get(adjacency, index)

      {new_type, new_trees, new_lumbers} =
        indices
        |> count_adjacents(grid, 0, 0)
        |> get_type(type, trees, lumbers)

      iterate_cells(index + 1, size, grid, adjacency, [new_type | cells], new_trees, new_lumbers)
    end

    defp get_type({trees_adjacents, _}, @open, trees, lumbers) when trees_adjacents > 2,
      do: {@tree, trees + 1, lumbers}

    defp get_type(_, @open, trees, lumbers), do: {@open, trees, lumbers}

    defp get_type({_, lumbers_adjacents}, @tree, trees, lumbers) when lumbers_adjacents > 2,
      do: {@lumberyard, trees, lumbers + 1}

    defp get_type(_, @tree, trees, lumbers), do: {@tree, trees + 1, lumbers}

    defp get_type({trees_adjacents, lumbers_adjacents}, @lumberyard, trees, lumbers)
         when trees_adjacents > 0 and lumbers_adjacents > 0,
         do: {@lumberyard, trees, lumbers + 1}

    defp get_type(_, @lumberyard, trees, lumbers), do: {@open, trees, lumbers}

    defp count_adjacents([], _, trees, lumbers), do: {trees, lumbers}

    defp count_adjacents([index | rest], grid, trees, lumbers) do
      case :binary.at(grid, index) do
        @tree -> count_adjacents(rest, grid, trees + 1, lumbers)
        @lumberyard -> count_adjacents(rest, grid, trees, lumbers + 1)
        _ -> count_adjacents(rest, grid, trees, lumbers)
      end
    end

    @spec do_sum({binary(), list(list(integer())), integer(), integer(), integer(), integer()}) ::
            integer()
    def do_sum({_, _, _, _, trees, lumbers}), do: trees * lumbers
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part()
      |> Enum.at(10)
      |> Common.do_sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part()
      |> do_part()
      |> Common.do_sum()
    end

    defp do_part(list) do
      {cycle_start, cycle_length} =
        list
        |> Stream.with_index()
        |> Enum.reduce_while(Map.new(), fn {{grid, _, _, _, _, _}, index}, seen ->
          case Map.get(seen, grid) do
            nil -> {:cont, Map.put(seen, grid, index)}
            old_index -> {:halt, {old_index, index - old_index}}
          end
        end)

      remainder = rem(1_000_000_000 - cycle_start, cycle_length)

      Enum.at(list, cycle_start + remainder)
    end
  end
end
