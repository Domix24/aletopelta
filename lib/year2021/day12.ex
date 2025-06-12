defmodule Aletopelta.Year2021.Day12 do
  @moduledoc """
  Day 12 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: [binary()]
    @type graph() :: %{binary() => [binary()]}
    @type handle_small() :: (binary(),
                             graph(),
                             [binary()],
                             MapSet.t(binary()),
                             boolean(),
                             handle_small() ->
                               [list(binary())])

    @spec parse_input(input()) :: graph()
    def parse_input(input) do
      Enum.reduce(input, %{}, fn line, map_acc ->
        [part1, part2] = String.split(line, "-")

        map_acc
        |> Map.update(part1, [part2], &[part2 | &1])
        |> Map.update(part2, [part1], &[part1 | &1])
      end)
    end

    @spec traverse([binary()], graph(), [binary()], MapSet.t(binary()), boolean(), any()) :: [
            list(binary())
          ]
    def traverse(caves, map, list, visited, twice?, handle_small) do
      Enum.flat_map(caves, fn
        "start" ->
          []

        "end" ->
          [["end" | list]]

        <<code, _::binary>> = cave when code in ?a..?z ->
          handle_small.(cave, map, list, visited, twice?, handle_small)

        <<code, _::binary>> = cave when code in ?A..?Z ->
          map
          |> Map.fetch!(cave)
          |> traverse(map, [cave | list], visited, twice?, handle_small)
      end)
    end

    @spec handle_small(
            binary(),
            graph(),
            [binary()],
            MapSet.t(binary()),
            boolean(),
            handle_small()
          ) :: [list(binary())]
    def handle_small(cave, map, list, visited, twice?, handle_small) do
      if MapSet.member?(visited, cave) do
        []
      else
        map
        |> Map.fetch!(cave)
        |> Common.traverse(map, [cave | list], MapSet.put(visited, cave), twice?, handle_small)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> traverse()
      |> Enum.count()
    end

    defp traverse(map) do
      map
      |> Map.fetch!("start")
      |> Common.traverse(map, ["start"], MapSet.new(), false, &Common.handle_small/6)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> traverse()
      |> Enum.count()
    end

    defp traverse(map) do
      map
      |> Map.fetch!("start")
      |> Common.traverse(map, ["start"], MapSet.new(), false, &handle_small/6)
    end

    defp handle_small(cave, map, list, visited, twice?, handle_small) do
      if not twice? and MapSet.member?(visited, cave) do
        map
        |> Map.fetch!(cave)
        |> Common.traverse(map, [cave | list], visited, true, handle_small)
      else
        Common.handle_small(cave, map, list, visited, twice?, handle_small)
      end
    end
  end
end
