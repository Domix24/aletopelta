defmodule Aletopelta.Year2025.Day08 do
  @moduledoc """
  Day 8 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type box() :: list(integer())
    @type boxes() :: list(box())

    @spec parse_input(input()) :: boxes()
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)
    end

    defp line([x1, y1, z1], [x2, y2, z2]), do: (x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2

    @spec do_loop(boxes()) ::
            Enumerable.t(%{
              pairs: list({box(), box(), integer()}),
              connections: integer(),
              links: %{integer() => boxes()},
              set: MapSet.t(integer())
            })
    def do_loop(boxes) do
      boxes
      |> shortest()
      |> Enum.sort_by(&elem(&1, 2))
      |> do_connect(boxes)
    end

    defp do_connect(pairs, boxes) do
      links =
        boxes
        |> Enum.with_index()
        |> Map.new(&{elem(&1, 1), [elem(&1, 0)]})

      set =
        links
        |> Map.keys()
        |> MapSet.new()

      Stream.iterate(
        %{pairs: pairs, connections: 0, links: links, last: [], set: set},
        &connect/1
      )
    end

    defp shortest([]), do: []

    defp shortest([box | boxes]),
      do: Enum.map(boxes, &{box, &1, line(box, &1)}) ++ shortest(boxes)

    defp connect(
           %{pairs: [{part1, part2, _} | pairs], connections: connections, links: links, set: set} =
             state
         ) do
      [{index_part1, list_part1}, {index_part2, list_part2}] = find_group(part1, part2, links)

      new_set = reduce_set(set, index_part1, index_part2)
      last = [part1, part2]
      new_connections = connections + 1

      new_links =
        if index_part1 === index_part2 do
          links
        else
          links
          |> Map.update!(index_part1, fn _ -> list_part1 ++ list_part2 end)
          |> Map.delete(index_part2)
        end

      next(state, pairs, new_connections, new_links, last, new_set)
    end

    defp find_group(part1, part2, links),
      do: Enum.map([part1, part2], &Enum.find(links, fn {_, boxes} -> &1 in boxes end))

    defp reduce_set(set, index1, index2), do: MapSet.difference(set, MapSet.new([index1, index2]))

    defp next(state, pairs, connections, links, last, set),
      do: %{state | pairs: pairs, connections: connections, links: links, last: last, set: set}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop()
      |> Enum.find(&(&1.connections === 1000))
      |> Map.fetch!(:links)
      |> Enum.map(fn {_, list} -> Enum.count(list) end)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.product()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop()
      |> Enum.find(&(MapSet.size(&1.set) < 1))
      |> Map.fetch!(:last)
      |> Enum.map(fn [x, _, _] -> x end)
      |> Enum.product()
    end
  end
end
