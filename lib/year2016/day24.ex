defmodule Aletopelta.Year2016.Day24 do
  @moduledoc """
  Day 24 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type grid() :: %{{integer(), integer()} => integer()}

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn cell, x -> {{x, y}, convert(cell)} end)
        |> Enum.reject(&(elem(&1, 1) > 10))
      end)
      |> Map.new()
    end

    defp convert("."), do: 10
    defp convert("#"), do: 11
    defp convert(cell), do: String.to_integer(cell)

    @spec execute(grid(), module()) :: output()
    def execute(grid, module),
      do:
        grid
        |> Enum.filter(fn {_, number} -> number < 10 end)
        |> find_distances(grid, extract(module))
        |> Enum.min()

    defp extract(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)

    defp search(source, target, grid), do: search([source], [], target, grid, 0, Map.new())

    defp search([], [], _, _, _, _), do: :nopath

    defp search([], list, goal, grid, steps, visited),
      do: search(list, [], goal, grid, steps + 1, visited)

    defp search([node | rest], list, goal, grid, steps, visited) do
      case check(node, goal, visited) do
        :final ->
          steps

        :visited ->
          search(rest, list, goal, grid, steps, visited)

        :new ->
          new_list = next(node, grid) ++ list

          new_visited = Map.put(visited, node, true)

          search(rest, new_list, goal, grid, steps, new_visited)
      end
    end

    defp next({x, y}, grid),
      do:
        [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
        |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
        |> Enum.reject(fn position -> Map.get(grid, position) === nil end)

    defp check({x, y}, {x, y}, _), do: :final
    defp check({x, y}, _, visited) when is_map_key(visited, {x, y}), do: :visited
    defp check(_, _, _), do: :new

    defp find_distances(numbers, grid, part),
      do:
        numbers
        |> combinations(2)
        |> Enum.flat_map(fn [{source, source_number}, {target, target_number}] ->
          source
          |> search(target, grid)
          |> copy(source_number, target_number)
        end)
        |> Map.new()
        |> find_minimal(numbers, part)

    defp copy(distance, source, target),
      do: [{[source, target], distance}, {[target, source], distance}]

    defp combinations(_, 0), do: [[]]
    defp combinations([], _), do: []

    defp combinations([head | tail], length) do
      with_head = for t <- combinations(tail, length - 1), do: [head | t]
      without_head = combinations(tail, length)
      with_head ++ without_head
    end

    defp find_minimal(distances, numbers, part),
      do:
        numbers
        |> Enum.map(&elem(&1, 1))
        |> permutations()
        |> Enum.reject(&(Enum.at(&1, 0) > 0))
        |> Enum.map(fn path ->
          path
          |> chunk(part)
          |> Enum.sum_by(&Map.fetch!(distances, &1))
        end)

    defp chunk(path, :part1), do: Enum.chunk_every(path, 2, 1, :discard)
    defp chunk(path, :part2), do: Enum.chunk_every(path, 2, 1, [0])

    defp permutations([]), do: [[]]

    defp permutations(list) do
      for head <- list, tail <- permutations(list -- [head]) do
        [head | tail]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end
end
