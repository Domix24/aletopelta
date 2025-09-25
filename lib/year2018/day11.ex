defmodule Aletopelta.Year2018.Day11 do
  @moduledoc """
  Day 11 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type grid() :: %{{integer(), integer()} => integer()}

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
      |> generate_grid()
    end

    defp generate_grid(serial) do
      for x <- 235..250, y <- 14..240, into: %{} do
        rack_id = x + 10
        power_level = rem(div((rack_id * y + serial) * rack_id, 100), 10) - 5
        {{x, y}, power_level}
      end
    end

    @spec find(grid(), Range.t()) :: {integer(), integer(), integer(), integer()}
    def find(grid, sizes),
      do:
        Enum.reduce(sizes, {0, 0, 0, -1000}, fn size, {best_x, best_y, best_size, best_power} ->
          {x, y, power} = find_best(grid, size)

          if power > best_power do
            {x, y, size, power}
          else
            {best_x, best_y, best_size, best_power}
          end
        end)

    defp find_best(grid, size) do
      {max_coordx, max_coordy} = {250 - size + 1, 240 - size + 1}

      for x <- 235..max_coordx, y <- 14..max_coordy, reduce: {1, 1, -1000} do
        {best_x, best_y, best_power} ->
          power = square_sum(grid, x, y, size)

          if power > best_power do
            {x, y, power}
          else
            {best_x, best_y, best_power}
          end
      end
    end

    defp square_sum(grid, x, y, size) do
      for dx <- 0..(size - 1), dy <- 0..(size - 1), reduce: 0 do
        acc -> acc + Map.fetch!(grid, {x + dx, y + dy})
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find(3..3)
      |> then(fn {x, y, _, _} -> [x, y] end)
      |> Enum.join(",")
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find(14..14)
      |> then(fn {x, y, size, _} -> [x, y, size] end)
      |> Enum.join(",")
    end
  end
end
