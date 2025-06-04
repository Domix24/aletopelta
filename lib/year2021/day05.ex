defmodule Aletopelta.Year2021.Day05 do
  @moduledoc """
  Day 5 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """
    @spec parse_input([binary()]) :: [{Range.t(), Range.t(), {integer(), integer()}, {integer(), integer()}}]
    def parse_input(input) do
      Enum.map(input, fn line ->
        [x0, y0, x1, y1] = ~r/\d+/
        |> Regex.scan(line)
        |> Enum.flat_map(&(&1))
        |> Enum.map(&String.to_integer/1)

        xrange = Range.new(min(x0, x1), max(x0, x1))
        yrange = Range.new(min(y0, y1), max(y0, y1))

        {xrange, yrange, {x0, y0}, {x1, y1}}
      end)
    end

    defp get_points({_.._//1 = x_range, y..y//1, _, _}) do
      for x <- x_range, do: {x, y}
    end
    defp get_points({x..x//1, _.._//1 = y_range, _, _}) do
      for y <- y_range, do: {x, y}
    end
    defp get_points({_, _, {x0, y0}, {x1, y1}}) when x1 > x0 and y1 > y0 do
      get_points({x0, y0}, {0 + 1, 0 + 1}, x1 - x0)
    end
    defp get_points({_, _, {x0, y0}, {x1, y1}}) when x1 > x0 and y1 < y0 do
      get_points({x0, y0}, {0 + 1, 0 - 1}, x1 - x0)
    end
    defp get_points({a, b, {x0, y0}, {x1, y1}}) do
      get_points({a, b, {x1, y1}, {x0, y0}})
    end

    defp get_points({x0, y0}, {dx, dy}, count) do
      for d <- Range.new(0, count), do: {x0 + dx * d, y0 + dy * d}
    end

    defp overlap_points(points) do
      points
      |> Enum.flat_map(&(&1))
      |> Enum.frequencies()
      |> Enum.count(fn {_, count} -> count > 1 end)
    end

    @spec get_overlap([{Range.t(), Range.t(), {integer(), integer()}, {integer(), integer()}}]) :: integer()
    def get_overlap(points) do
      points
      |> Enum.map(&get_points/1)
      |> overlap_points()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.reject(&diagonal?/1)
      |> Common.get_overlap()
    end

    defp diagonal?({_.._//1, y0..y0//1, _, _}), do: false
    defp diagonal?({x0..x0//1, _.._//1, _, _}), do: false
    defp diagonal?({_.._//1, _.._//1, _, _}), do: true
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_overlap()
    end
  end
end
