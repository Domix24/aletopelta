defmodule Aletopelta.Year2017.Day14 do
  @moduledoc """
  Day 14 of Year 2017
  """
  alias Aletopelta.Year2017.Knot

  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: Knot.input()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> Knot.parse()
    end

    @spec process(Knot.input()) :: list(Knot.hash())
    def process(input),
      do:
        Enum.map(0..127, fn row ->
          input
          |> Enum.concat(~c"-#{row}")
          |> Knot.new()
          |> String.graphemes()
          |> Enum.map_join(fn grapheme ->
            grapheme
            |> String.to_integer(16)
            |> Integer.to_string(2)
            |> String.pad_leading(4, "0")
          end)
        end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.process()
      |> Enum.sum_by(&used/1)
    end

    defp used(input),
      do:
        input
        |> String.graphemes()
        |> Enum.count(&(&1 === "1"))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.process()
      |> build_grid()
      |> regions()
    end

    defp build_grid(list) do
      list
      |> Enum.reduce({0, Map.new()}, fn line, {y, map} ->
        {_, new_map} =
          line
          |> String.graphemes()
          |> Enum.reduce({0, map}, fn
            "1", {x, map} -> {x + 1, Map.put(map, {x, y}, 1)}
            _, {x, map} -> {x + 1, map}
          end)

        {y + 1, new_map}
      end)
      |> elem(1)
    end

    defp regions(map, sum \\ 0) do
      case Enum.at(map, 0) do
        nil ->
          sum

        {position, 1} ->
          keys =
            map
            |> traverse(position, Map.new())
            |> Map.keys()

          map
          |> Map.drop(keys)
          |> regions(sum + 1)
      end
    end

    defp traverse(_, position, seen) when is_map_key(seen, position), do: seen

    defp traverse(map, {x, y} = position, seen) do
      new_seen = Map.put(seen, position, 1)

      Enum.reduce([{0, 1}, {0, -1}, {1, 0}, {-1, 0}], new_seen, fn {dx, dy}, acc_seen ->
        position = {x + dx, y + dy}

        case Map.get(map, position) do
          nil -> acc_seen
          1 -> traverse(map, position, acc_seen)
        end
      end)
    end
  end
end
