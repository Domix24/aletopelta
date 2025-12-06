defmodule Aletopelta.Year2025.Day04 do
  @moduledoc """
  Day 4 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())
    @type cell() :: {{integer(), integer()}, binary()}
    @type cellmap() :: %{{integer(), integer()} => binary()}

    @spec parse_input(input()) :: cellmap()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {line, y}, map ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reject(&(elem(&1, 0) === "."))
        |> Map.new(fn {roll, x} -> {{x, y}, roll} end)
        |> Map.merge(map)
      end)
    end

    @spec four?(cell(), cellmap()) :: boolean()
    def four?({position, "@"}, map) do
      total =
        position
        |> adjacents()
        |> Enum.map(&Map.get(map, &1))
        |> Enum.count(&roll?/1)

      total < 4
    end

    defp roll?(cell), do: cell === "@"

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

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(map) do
      Enum.sum_by(map, fn cell ->
        if Common.four?(cell, map), do: 1, else: 0
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(map) do
      %{map: map, removed: 0}
      |> remove()
      |> Stream.iterate(&remove/1)
      |> Stream.take_while(fn %{removed: removed} -> removed > 0 end)
      |> Enum.sum_by(fn %{removed: removed} -> removed end)
    end

    defp remove(%{map: map}) do
      {yes_four, no_four} = Enum.split_with(map, &Common.four?(&1, map))

      %{map: Map.new(no_four), removed: Enum.count(yes_four)}
    end
  end
end
