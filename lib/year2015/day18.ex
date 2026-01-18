defmodule Aletopelta.Year2015.Day18 do
  @moduledoc """
  Day 18 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type grid() :: %{{integer(), integer()} => :on | :off}

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn cell, x -> {{x, y}, convert(cell)} end)
      end)
      |> Map.new()
    end

    defp convert("."), do: :off
    defp convert("#"), do: :on

    @spec execute(grid(), module()) :: output()
    def execute(grid, module),
      do:
        module
        |> simply()
        |> execute(grid, :internal)

    defp execute(module, grid, :internal),
      do:
        grid
        |> Stream.iterate(&iterate(&1, module))
        |> Enum.at(100)
        |> Map.values()
        |> Enum.count(&(&1 === :on))

    defp iterate(grid, module),
      do:
        Enum.reduce(grid, grid, fn {{x, y} = position, state}, acc ->
          [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
          |> Enum.count_until(fn {dx, dy} -> Map.get(grid, {dx + x, dy + y}, :off) === :on end, 4)
          |> switch(state, position, acc, module)
        end)

    defp switch(count, :on, _, grid, _) when count in 2..3, do: grid
    defp switch(3, :off, position, grid, _), do: Map.put(grid, position, :on)

    defp switch(_, :on, position, grid, :part2)
         when position in [{0, 99}, {99, 0}, {0, 0}, {99, 99}], do: grid

    defp switch(_, :on, position, grid, _), do: Map.put(grid, position, :off)
    defp switch(_, :off, _, grid, _), do: grid

    defp simply(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> update()
      |> Common.execute(__MODULE__)
    end

    defp update(grid) do
      grid
      |> Map.put({0, 0}, :on)
      |> Map.put({99, 0}, :on)
      |> Map.put({0, 99}, :on)
      |> Map.put({99, 99}, :on)
    end
  end
end
