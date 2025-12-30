defmodule Aletopelta.Year2017.Day12 do
  @moduledoc """
  Day 12 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: %{integer() => integer()}
    def parse_input(input) do
      input
      |> Enum.flat_map(fn line ->
        [oleft, oright] = String.split(line, "<->")
        left = to_integer(oleft)

        right =
          oright
          |> String.split(",")
          |> Enum.map(&to_integer/1)

        Enum.flat_map(right, &[{&1, left}, {left, &1}])
      end)
      |> Enum.uniq()
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    end

    defp to_integer(string),
      do:
        string
        |> String.trim()
        |> String.to_integer()

    @spec find_group(%{integer() => integer()}, integer()) :: list(integer())
    def find_group(map, key),
      do:
        map
        |> find_group(key, Map.new(), [])
        |> elem(0)

    defp find_group(_, key, seen, group) when is_map_key(seen, key), do: {group, seen}

    defp find_group(map, key, seen, group) do
      new_seen = Map.put(seen, key, 1)

      map
      |> Map.fetch!(key)
      |> Enum.reduce({[key | group], new_seen}, fn subkey, {acc_group, acc_seen} ->
        find_group(map, subkey, acc_seen, acc_group)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_group(0)
      |> Enum.count()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> find_groups()
    end

    defp find_groups(map, count \\ 0) do
      case Enum.at(map, 0) do
        {node, _} ->
          group = Common.find_group(map, node)

          map
          |> Map.drop(group)
          |> find_groups(count + 1)

        nil ->
          count
      end
    end
  end
end
