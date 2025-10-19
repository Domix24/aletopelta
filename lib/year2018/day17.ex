defmodule Aletopelta.Year2018.Day17 do
  @moduledoc """
  Day 17 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: %{{integer(), integer()} => :wall}
    def parse_input(input) do
      input
      |> Enum.flat_map(fn line ->
        ~r"\d+|x|y"
        |> Regex.scan(line)
        |> Enum.flat_map(fn
          [value] when value in ["x", "y"] -> [value]
          [value] -> [String.to_integer(value)]
        end)
        |> parse()
      end)
      |> Map.new(&{&1, :wall})
    end

    defp parse(["x", x, "y", yvalue1, yvalue2]), do: Enum.map(yvalue1..yvalue2, &{x, &1})
    defp parse(["x", xvalue1, xvalue2, "y", y]), do: Enum.map(xvalue1..xvalue2, &{&1, y})
    defp parse(["y", y, "x", xvalue1, xvalue2]), do: parse(["x", xvalue1, xvalue2, "y", y])
    defp parse(["y", yvalue1, yvalue2, "x", x]), do: parse(["x", x, "y", yvalue1, yvalue2])

    @spec do_part(%{{integer(), integer()} => :wall}) :: %{
            {integer(), integer()} => :wall | :waterfall | :water
          }
    def do_part(parsed) do
      {{{_, miny}, _}, {{_, maxy}, _}} = Enum.min_max_by(parsed, fn {{_, y}, _} -> y end)

      fill(parsed, {500, miny}, maxy)
    end

    defp fill(parsed, {x, y}, y), do: Map.put(parsed, {x, y}, :waterfall)

    defp fill(parsed, {x, y}, max),
      do:
        parsed
        |> Map.get({x, y + 1})
        |> do_fill(parsed, {x, y}, max)

    defp do_fill(nil, parsed, {x, y}, max) do
      new_parsed = Map.put(parsed, {x, y}, :waterfall)
      new_newparsed = fill(new_parsed, {x, y + 1}, max)

      case Map.get(new_newparsed, {x, y + 1}) do
        :water ->
          fill(new_newparsed, {x, y}, max)

        :waterfall ->
          new_newparsed
      end
    end

    defp do_fill(:waterfall, parsed, {x, y}, _), do: Map.put(parsed, {x, y}, :waterfall)

    defp do_fill(_, parsed, {x, y}, max) do
      {leftx, leftactual} =
        x
        |> Stream.iterate(&(&1 - 1))
        |> find_value(parsed, y)

      {rightx, rightactual} =
        (x + 1)
        |> Stream.iterate(&(&1 + 1))
        |> find_value(parsed, y)

      do_next({leftactual, rightactual}, {leftx, rightx}, parsed, y, max)
    end

    defp do_next({:wall, :wall}, horizontal, parsed, y, _),
      do: fill_horizontal(horizontal, parsed, y, :water)

    defp do_next(actual, horizontal, parsed, y, max),
      do:
        horizontal
        |> fill_horizontal(parsed, y, :waterfall)
        |> fill_side(actual, horizontal, y, max)

    defp fill_side(parsed, {:wall, _}, {_, x}, y, max), do: fill(parsed, {x, y}, max)
    defp fill_side(parsed, {_, :wall}, {x, _}, y, max), do: fill(parsed, {x, y}, max)

    defp fill_side(parsed, _, {leftx, rightx}, y, max),
      do:
        parsed
        |> fill({leftx, y}, max)
        |> fill({rightx, y}, max)

    defp fill_horizontal({leftx, rightx}, parsed, y, symbol),
      do: Enum.reduce((leftx + 1)..(rightx - 1), parsed, &Map.put(&2, {&1, y}, symbol))

    defp find_value(enumerable, map, y) do
      Enum.find_value(enumerable, fn x ->
        case {Map.get(map, {x, y}), Map.get(map, {x, y + 1})} do
          {:wall, _} -> {x, :wall}
          {nil, nil} -> {x, nil}
          _ -> nil
        end
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part()
      |> Enum.count(&(elem(&1, 1) in [:water, :waterfall]))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part()
      |> Enum.count(&(elem(&1, 1) in [:water]))
    end
  end
end
