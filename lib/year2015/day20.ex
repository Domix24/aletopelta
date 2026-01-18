defmodule Aletopelta.Year2015.Day20 do
  @moduledoc """
  Day 20 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: integer()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
    end

    @spec execute(integer(), integer(), integer(), integer()) :: output()
    def execute(present, factor, visits, seed) do
      seed
      |> Stream.iterate(&(&1 + 1))
      |> Enum.find(fn house ->
        sum =
          house
          |> divisors()
          |> limit_visits(visits, house)
          |> Enum.sum()

        sum * factor >= present
      end)
    end

    defp divisors(number) do
      limit =
        number
        |> :math.sqrt()
        |> trunc()

      divisors =
        for x <- 1..limit,
            rem(number, x) < 1,
            divisor <- if(x * x === number, do: [x], else: [x, div(number, x)]) do
          divisor
        end

      divisors
    end

    defp limit_visits(visits, 0, _), do: visits
    defp limit_visits(visits, limit, house), do: Enum.filter(visits, &(div(house, &1) <= limit))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(10, 0, 650_000)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(11, 50, 700_000)
    end
  end
end
