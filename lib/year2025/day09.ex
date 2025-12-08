defmodule Aletopelta.Year2025.Day09 do
  @moduledoc """
  Day 9 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list({integer(), integer()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [x, y] =
          line
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)

        {x, y}
      end)
    end

    @spec area({integer(), integer()}, {integer(), integer()}) :: integer()
    def area({x1, y1}, {x2, y2}), do: (abs(y2 - y1) + 1) * (abs(x2 - x1) + 1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(points), do: do_loop(0, points)

    defp do_loop(max, [_]), do: max

    defp do_loop(max, [first | rest]),
      do:
        rest
        |> Enum.map(&Common.area(first, &1))
        |> Enum.max()
        |> max(max)
        |> do_loop(rest)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_process()
      |> Enum.reduce(0, fn {_, area}, best -> max(area, best) end)
    end

    defp do_process(points) do
      {horizontal, vertical} = link_points(points)

      points
      |> get_rectangles()
      |> Enum.filter(fn {rectangle, _} -> inside?(rectangle, horizontal, vertical) end)
    end

    defp link_points([point | points]), do: link_points(points, [], [], point)

    defp link_points(_, horizontal, vertical, nil), do: {horizontal, vertical}

    defp link_points([{x, py1}, {x, py2} = point | points], horizontal, vertical, first),
      do:
        link_points(
          [point | points],
          horizontal,
          [{x, min(py1, py2)..max(py1, py2)} | vertical],
          first
        )

    defp link_points([{px1, y}, {px2, y} = point | points], horizontal, vertical, first),
      do:
        link_points(
          [point | points],
          [{y, min(px1, px2)..max(px1, px2)} | horizontal],
          vertical,
          first
        )

    defp link_points([point], horizontal, vertical, first),
      do: link_points([point, first], horizontal, vertical, nil)

    defp get_rectangles(points), do: get_rectangles([], points)

    defp get_rectangles(rectangles, [_]), do: rectangles

    defp get_rectangles(rectangles, [first | rest]),
      do:
        rest
        |> Enum.map(&rectangle(first, &1))
        |> Enum.concat(rectangles)
        |> get_rectangles(rest)

    defp rectangle({x1, y1} = p1, {x2, y2} = p2),
      do: {{min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2)}, Common.area(p1, p2)}

    defp inside?(rectangle, horizontal, vertical) do
      not horizontal?(rectangle, horizontal) and not vertical?(rectangle, vertical)
    end

    defp horizontal?(rectangle, horizontals) do
      {xa, xo, ya, yo} = rectangle

      Enum.any?(horizontals, fn horizontal ->
        {y, xha..xho//1} = horizontal
        y > ya and y < yo and not (xho <= xa or xha >= xo)
      end)
    end

    defp vertical?(rectangle, verticals) do
      {xa, xo, ya, yo} = rectangle

      Enum.any?(verticals, fn vertical ->
        {x, yha..yho//1} = vertical
        x > xa and x < xo and not (yho <= ya or yha >= yo)
      end)
    end
  end
end
