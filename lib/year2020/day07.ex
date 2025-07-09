defmodule Aletopelta.Year2020.Day07 do
  @moduledoc """
  Day 7 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())

    @spec parse_input(input()) ::
            {%{binary() => %{binary() => integer()}}, %{binary() => list(binary())}}
    def parse_input(input) do
      Enum.reduce(input, {%{}, %{}}, fn line, {acc_bag, acc_count} ->
        [[_, bag, bags]] = Regex.scan(~r/^(\w+ \w+) bags? contain (.+)$/, line)

        bagsmap = create_bagmap(bags)

        new_accbag = Map.put(acc_bag, bag, bagsmap)

        new_acccount =
          bagsmap
          |> Map.keys()
          |> Enum.reduce(acc_count, fn subibag, acccount ->
            Map.update(acccount, subibag, [bag], &[bag | &1])
          end)

        {new_accbag, new_acccount}
      end)
    end

    defp create_bagmap(bags) do
      ~r/(\d+) (\w+ \w+) b/
      |> Regex.scan(bags, capture: :all_but_first)
      |> Enum.map(fn [number, subbag] ->
        {subbag, String.to_integer(number)}
      end)
      |> Map.new()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> traverse("shiny gold")
    end

    defp traverse({_, countmap}, bag) do
      traverse(countmap, [bag], MapSet.new([]))
    end

    defp traverse(_, [], visited), do: MapSet.size(visited)

    defp traverse(countmap, [_ | _] = bags, visited) do
      new_bags =
        bags
        |> Enum.flat_map(&Map.get(countmap, &1, []))
        |> Enum.uniq()
        |> Enum.reject(&MapSet.member?(visited, &1))

      new_visited =
        new_bags
        |> MapSet.new()
        |> MapSet.union(visited)

      traverse(countmap, new_bags, new_visited)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> traverse("shiny gold")
    end

    defp traverse({bagmap, _}, bag) do
      traverse(bagmap, bag)
    end

    defp traverse(bagmap, bag) do
      bagmap
      |> Map.get(bag, [])
      |> Enum.reduce(0, fn {other_bag, count}, acc_sum ->
        acc_sum + count + count * traverse(bagmap, other_bag)
      end)
    end
  end
end
