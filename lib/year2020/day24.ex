defmodule Aletopelta.Year2020.Day24 do
  @moduledoc """
  Day 24 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type coordinate() :: %{x: integer(), y: integer(), z: integer()}
    @type output() :: list(coordinate())

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r/se|sw|nw|ne|e|w/
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.reduce(%{x: 0, y: 0, z: 0}, &increment_position/2)
      end)
    end

    @spec increment_position(binary(), coordinate()) :: coordinate()
    def increment_position("e", %{x: x, y: y, z: z}), do: %{x: x + 1, y: y, z: z - 1}
    def increment_position("ne", %{x: x, y: y, z: z}), do: %{x: x, y: y + 1, z: z - 1}
    def increment_position("se", %{x: x, y: y, z: z}), do: %{x: x + 1, y: y - 1, z: z}
    def increment_position("nw", %{x: x, y: y, z: z}), do: %{x: x - 1, y: y + 1, z: z}
    def increment_position("sw", %{x: x, y: y, z: z}), do: %{x: x, y: y - 1, z: z + 1}
    def increment_position("w", %{x: x, y: y, z: z}), do: %{x: x - 1, y: y, z: z + 1}

    @spec get_blacks(output()) :: output()
    def get_blacks(tiles) do
      tiles
      |> Enum.frequencies()
      |> Enum.filter(&black?/1)
    end

    defp black?({_, count}), do: rem(count, 2) == 1
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_blacks()
      |> Enum.count()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_blacks()
      |> Map.new()
      |> do_loop(100)
      |> Enum.count()
    end

    defp get_sides({position, _}) do
      Enum.map(["e", "w", "sw", "se", "nw", "ne"], &Common.increment_position(&1, position))
    end

    defp do_loop(blacks, 0), do: Enum.reject(blacks, &(elem(&1, 0) == nil))

    defp do_loop(blacks, max) do
      blacks
      |> Enum.reject(&(elem(&1, 0) == nil))
      |> Enum.flat_map(&get_sides/1)
      |> Enum.frequencies()
      |> Map.new(fn {position, count} ->
        process_map(position, count, Map.has_key?(blacks, position))
      end)
      |> do_loop(max - 1)
    end

    defp process_map(_, count, true) when count < 1 when count > 2, do: {nil, 0}
    defp process_map(position, 2, false), do: {position, 0}
    defp process_map(position, _, true), do: {position, 0}
    defp process_map(_, _, _), do: {nil, 0}
  end
end
