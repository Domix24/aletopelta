defmodule Aletopelta.Year2017.Day22 do
  @moduledoc """
  Day 22 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())
    @type output() :: none()
    @type grid() :: %{{integer(), integer()} => state()}
    @type state() :: :clean | :weakened | :infected | :flagged

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn cell, x ->
          {{x, y}, convert(cell)}
        end)
      end)
      |> Map.new()
    end

    defp convert("."), do: :clean
    defp convert("#"), do: :infected

    @spec move_virus(grid(), :part1 | :part2) :: integer()
    def move_virus(grid, part),
      do:
        {find_center(grid), {0, -1}, grid, false, part}
        |> Stream.iterate(&move/1)
        |> Stream.take(take(part) + 1)
        |> Enum.count(&elem(&1, 3))

    defp take(:part1), do: 10_000
    defp take(:part2), do: 10_000_000

    defp move({position, _, grid, _, _} = info),
      do:
        grid
        |> Map.get(position, :clean)
        |> move(info)

    defp move(cell, {{x, y} = position, facing, grid, _, part}) do
      {dx, dy} = new_facing = change_facing(cell, facing)
      new_grid = Map.put(grid, position, change_cell(cell, part))
      new_position = {x + dx, y + dy}

      {new_position, new_facing, new_grid, got_infected?(cell, part), part}
    end

    defp change_facing(:clean, facing), do: left(facing)
    defp change_facing(:infected, facing), do: right(facing)
    defp change_facing(:weakened, facing), do: facing
    defp change_facing(:flagged, facing), do: inverse(facing)

    defp change_cell(:clean, :part1), do: :infected
    defp change_cell(:infected, :part1), do: :clean

    defp change_cell(:clean, :part2), do: :weakened
    defp change_cell(:weakened, _), do: :infected
    defp change_cell(:infected, :part2), do: :flagged
    defp change_cell(:flagged, _), do: :clean

    defp got_infected?(:clean, :part1), do: true
    defp got_infected?(:weakened, _), do: true
    defp got_infected?(_, _), do: false

    defp left({x, y}), do: {y, -x}
    defp right({x, y}), do: {-y, x}
    defp inverse({x, y}), do: {-x, -y}

    defp find_center(grid),
      do:
        grid
        |> Enum.max_by(fn {{v, _}, _} -> v end)
        |> elem(0)
        |> elem(0)
        |> div(2)
        |> process_center()

    defp process_center(center), do: {center, center}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.move_virus(:part1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.move_virus(:part2)
    end
  end
end
