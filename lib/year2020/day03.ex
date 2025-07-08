defmodule Aletopelta.Year2020.Day03 do
  @moduledoc """
  Day 3 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())
    @type output() :: {%{{integer(), integer()} => binary()}, integer(), integer()}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      {grid, max_x, max_y} =
        Enum.reduce(input, {[], 0, 0}, fn line, {acc_line, _, y} ->
          {new_line, max_x} =
            line
            |> String.graphemes()
            |> Enum.reduce({acc_line, 0}, fn cell, {acc_cell, x} ->
              {[{{x, y}, cell} | acc_cell], x + 1}
            end)

          {new_line, max_x, y + 1}
        end)

      {Map.new(grid), max_x, max_y}
    end

    @spec test_slope(output(), {integer(), integer()}) :: integer()
    def test_slope(info, slope), do: test_slope(info, slope, slope)

    defp test_slope(info, point, slope),
      do:
        point
        |> normalize(info)
        |> tree?(info)
        |> next_point(info, point, slope)

    defp normalize({x, y}, {_, max_x, _}), do: {rem(x, max_x), y}

    defp tree?(point, {grid, _, _}), do: Map.fetch!(grid, point) == "#"

    defp next_point(state, {_, _, max_y}, {_, y}, {_, slope_y}) when y + slope_y + 1 > max_y,
      do: to_number(state)

    defp next_point(state, info, {x, y}, {slope_x, slope_y} = slope),
      do: to_number(state) + test_slope(info, {x + slope_x, y + slope_y}, slope)

    defp to_number(true), do: 1
    defp to_number(false), do: 0
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.test_slope({3, 1})
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> test_slopes()
      |> Enum.product()
    end

    defp test_slopes(info),
      do: Enum.map([{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}], &Common.test_slope(info, &1))
  end
end
