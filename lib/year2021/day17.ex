defmodule Aletopelta.Year2021.Day17 do
  @moduledoc """
  Day 17 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: [binary()]

    @spec parse_input(input()) :: {Range.t(), Range.t()}
    def parse_input(input) do
      [x1, x2, y1, y2] =
        Enum.flat_map(input, fn line ->
          ~r/-?\d+/
          |> Regex.scan(line)
          |> Enum.map(fn [capture] ->
            String.to_integer(capture)
          end)
        end)

      x_range =
        x1
        |> min(x2)
        |> Range.new(max(x1, x2))

      y_range =
        y1
        |> min(y2)
        |> Range.new(max(y1, y2))

      {x_range, y_range}
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
      |> find_max()
    end

    defp find_max({_, y_min.._//1}) do
      max_vy = abs(y_min) - 1

      div(max_vy * (max_vy + 1), 2)
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
      |> get_velocities()
      |> Enum.count()
    end

    defp get_velocities({_..x_max//1, y_min.._//1} = target) do
      for vx <- 1..x_max,
          vy <- y_min..abs(y_min),
          velocity <- [{vx, vy}],
          hits?(velocity, target),
          do: velocity
    end

    defp hits?({_, _} = velocity, target), do: simulate?({0, 0}, velocity, target)

    defp simulate?({x, y}, _, {x_min..x_max//1, y_min..y_max//1})
         when x >= x_min and x <= x_max and y >= y_min and y <= y_max,
         do: true

    defp simulate?({x, y}, {vx, _}, {x_min..x_max//1, y_min.._//1})
         when x > x_max or y < y_min or (vx == 0 and x < x_min),
         do: false

    defp simulate?({x, y}, {vx, vy}, target) do
      position = {x + vx, y + vy}
      velocity = {max(0, vx - 1), vy - 1}

      simulate?(position, velocity, target)
    end
  end
end
