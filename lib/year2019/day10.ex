defmodule Aletopelta.Year2019.Day10 do
  @moduledoc """
  Day 10 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type position() :: {integer(), integer()}
    @type normal() :: position()
    @type distance() :: integer()
    @type asteroids :: list(position())

    @spec parse_input(input()) :: asteroids()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn cell, x -> {{x, y}, cell} end)
        |> Enum.filter(&(elem(&1, 1) == "#"))
        |> Enum.map(fn {{x, y}, _} -> {x, y} end)
      end)
    end

    @spec get_station(asteroids()) :: list({position(), normal(), distance()})
    def get_station(asteroids) do
      asteroids
      |> Enum.map(fn asteroid ->
        relative = relative_asteroids(asteroid, asteroids)
        {asteroid, relative}
      end)
      |> Enum.max_by(fn {_, asteroids} -> Enum.count(asteroids) end)
      |> elem(1)
    end

    defp relative_asteroids(asteroid, asteroids) do
      asteroids
      |> Enum.map(&get_normal(&1, asteroid))
      |> Enum.filter(&(elem(&1, 2) > 0))
      |> Enum.group_by(&elem(&1, 1))
      |> Enum.map(fn
        {1, [asteroid]} -> asteroid
        {_, asteroids} -> get_closest(asteroids)
      end)
    end

    defp get_normal({x2, y2} = asteroid, {x1, y1}) do
      difference = {dx, dy} = {x2 - x1, y1 - y2}
      normal = normalize_slope(difference)
      distance = abs(dx) + abs(dy)

      {asteroid, normal, distance}
    end

    defp normalize_slope({0, 0}), do: {0, 0}

    defp normalize_slope({x, y}) do
      divisor =
        x
        |> gcd(y)
        |> abs()

      {div(x, divisor), div(y, divisor)}
    end

    defp gcd(a, 0), do: a
    defp gcd(a, b), do: gcd(b, rem(a, b))

    defp get_closest(asteroids),
      do:
        asteroids
        |> Enum.sort_by(&elem(&1, 2))
        |> Enum.at(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_station()
      |> Enum.count()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_station()
      |> Enum.sort(&sort_asteroids/2)
      |> Enum.at(199)
      |> product()
    end

    defp product({{x, y}, _, _}), do: x * 100 + y

    defp sort_asteroids({_, {x1, _}, _}, {_, {x2, _}, _}) when x1 >= 0 and x2 < 0, do: true
    defp sort_asteroids({_, {x1, _}, _}, {_, {x2, _}, _}) when x2 >= 0 and x1 < 0, do: false

    defp sort_asteroids({_, {x1, y1}, _}, {_, {x2, y2}, _}), do: x1 * y2 - y1 * x2 < 0
  end
end
