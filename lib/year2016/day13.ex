defmodule Aletopelta.Year2016.Day13 do
  @moduledoc """
  Day 13 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: integer()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
    end

    @spec search(integer(), integer() | {integer(), integer()}) :: integer()
    def search(input, goal), do: search([{1, 1}], [], goal, Map.new(), 0, input)

    defp search([], [], _, _, _, _), do: :nopath
    defp search([], _, goal, visited, goal, _), do: map_size(visited)

    defp search([], list, goal, visited, steps, favorite),
      do:
        list
        |> Enum.reject(&visited?(&1, visited))
        |> search([], goal, visited, steps + 1, favorite)

    defp search([node | rest], list, goal, visited, steps, favorite) do
      case check(node, visited, goal) do
        :final ->
          steps

        :visited ->
          search(rest, list, goal, visited, steps, favorite)

        :new ->
          new_list = next(node, favorite) ++ list
          new_visited = Map.put(visited, normalize(node), 1)

          search(rest, new_list, goal, new_visited, steps, favorite)
      end
    end

    defp next({x, y}, favorite) do
      [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
      |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
      |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or identify(x, y, favorite) === :wall end)
    end

    defp identify(x, y, favorite),
      do:
        (x * x + 3 * x + 2 * x * y + y + y * y + favorite)
        |> Integer.to_charlist(2)
        |> Enum.count(&(&1 === ?1))
        |> identify()

    defp identify(ones) when rem(ones, 2) < 1, do: :open
    defp identify(_), do: :wall

    defp normalize(node), do: node
    defp visited?(node, visited), do: is_map_key(visited, node)

    defp check(goal, _, goal), do: :final
    defp check(node, visited, _) when is_map_key(visited, node), do: :visited
    defp check(_, _, _), do: :new
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.search({31, 39})
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.search(50)
    end
  end
end
