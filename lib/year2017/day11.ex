defmodule Aletopelta.Year2017.Day11 do
  @moduledoc """
  Day 11 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type cardinal() :: :se | :sw | :ne | :nw | :n | :s

    @spec parse_input(input()) :: list(cardinal())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.flat_map(&~w"#{&1}"a)
    end

    @spec follow_path(list(cardinal())) :: {integer(), {integer(), integer(), integer()}}
    def follow_path(directions) do
      Enum.reduce(directions, {0, {0, 0, 0}}, fn cardinal, {furthest, position} ->
        cardinal
        |> move(position)
        |> compare(furthest)
      end)
    end

    defp move(:se, {x, a, b}), do: {x + 1, a - 1, b}
    defp move(:nw, {x, a, b}), do: {x - 1, a + 1, b}
    defp move(:sw, {x, a, b}), do: {x - 1, a, b + 1}
    defp move(:ne, {x, a, b}), do: {x + 1, a, b - 1}
    defp move(:s, {x, a, b}), do: {x, a - 1, b + 1}
    defp move(:n, {x, a, b}), do: {x, a + 1, b - 1}

    defp compare(position, distance), do: {max(distance, find_steps(position)), position}

    @spec find_steps({integer(), integer(), integer()}) :: integer()
    def find_steps({x, a, b}), do: div(abs(x) + abs(a) + abs(b), 2)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.follow_path()
      |> elem(1)
      |> Common.find_steps()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.follow_path()
      |> elem(0)
    end
  end
end
