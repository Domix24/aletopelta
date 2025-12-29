defmodule Aletopelta.Year2017.Day03 do
  @moduledoc """
  Day 3 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: integer()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
    end

    @spec find_path(integer()) :: {integer(), integer()}
    def find_path(number) do
      ring_distance = div(ceil(:math.sqrt(number)), 2)
      number_offset = number - (2 * ring_distance - 1) * (2 * ring_distance - 1)
      offset = rem(number_offset - 1, 2 * ring_distance) - ring_distance + 1

      case div(number_offset - 1, 2 * ring_distance) do
        0 -> {ring_distance, -offset}
        1 -> {-offset, -ring_distance}
        2 -> {-ring_distance, offset}
        3 -> {offset, ring_distance}
      end
    end

    @spec manhattan({integer(), integer()}) :: integer()
    def manhattan({x, y}), do: abs(x) + abs(y)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_path()
      |> Common.manhattan()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(check) do
      grid = Map.new([{{0, 0}, 1}])

      2
      |> Stream.iterate(&(&1 + 1))
      |> Stream.transform(grid, fn index, acc ->
        position = Common.find_path(index)

        value =
          position
          |> adjacents()
          |> Enum.sum_by(&Map.get(acc, &1, 0))

        {[value], Map.put(acc, position, value)}
      end)
      |> Enum.find(&(check < &1))
    end

    defp adjacents({x, y}),
      do: [
        {x - 1, y - 1},
        {x, y - 1},
        {x + 1, y - 1},
        {x - 1, y},
        {x + 1, y},
        {x - 1, y + 1},
        {x, y + 1},
        {x + 1, y + 1}
      ]
  end
end
