defmodule Aletopelta.Year2016.Day08 do
  @moduledoc """
  Day 8 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type output() :: none()
    @type instructions() :: list(rect() | rotate())
    @type rect() :: {:rect, integer(), integer()}
    @type rotate() :: {:rotate, :x | :y, integer(), integer()}

    @spec parse_input(input()) :: instructions()
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split()
        |> parse_specific()
      end)
    end

    defp parse_specific(["rect", size]) do
      [column, row] =
        ~r"\d+"
        |> Regex.scan(size)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)

      {:rect, column, row}
    end

    defp parse_specific(["rotate", _, sdirection, _, soffset]) do
      [saxis, sindex] = String.split(sdirection, "=")
      [axis] = ~w"#{saxis}"a
      [index, offset] = Enum.map([sindex, soffset], &String.to_integer/1)

      {:rotate, axis, index, offset}
    end

    @spec follow_instructions(instructions()) :: %{{integer(), integer()} => boolean()}
    def follow_instructions(instructions), do: Enum.reduce(instructions, Map.new(), &reduce/2)

    defp reduce({:rect, column, row}, grid) do
      for x <- 0..(column - 1), y <- 0..(row - 1), reduce: grid do
        acc -> Map.put(acc, {x, y}, true)
      end
    end

    defp reduce({:rotate, :y, y, offset}, grid) do
      for x <- 0..49,
          actual <- [Map.get(grid, {x, y}, false)],
          reduce: grid do
        acc -> Map.put(acc, {rem(x + offset, 50), y}, actual)
      end
    end

    defp reduce({:rotate, :x, x, offset}, grid) do
      for y <- 0..5,
          actual <- [Map.get(grid, {x, y}, false)],
          reduce: grid do
        acc -> Map.put(acc, {x, rem(y + offset, 6)}, actual)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.follow_instructions()
      |> Enum.count(&elem(&1, 1))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: list(binary())
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.follow_instructions()
      |> output()
    end

    defp output(grid) do
      for y <- 0..5 do
        for x <- 0..49, into: "" do
          case Map.get(grid, {x, y}, false) do
            false -> " "
            true -> "#"
          end
        end
      end
    end
  end
end
