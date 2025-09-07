defmodule Aletopelta.Year2019.Day24 do
  @moduledoc """
  Day 24 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type position() :: {integer(), integer(), integer()}
    @type cell() :: %{bug?: boolean(), empty?: boolean()}
    @type grid() :: %{position() => cell()}

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index -> {index, String.graphemes(line)} end)
      |> Enum.flat_map(fn {y, line} ->
        Enum.with_index(line, fn symbol, x -> {{x, y, 0}, symbol} end)
      end)
      |> Map.new(fn
        {position, "#"} -> {position, %{bug?: true, empty?: false}}
        {position, "."} -> {position, %{bug?: false, empty?: true}}
      end)
    end

    defp convert_cell(1, position, %{bug?: true} = cell), do: {position, cell}
    defp convert_cell(_, position, %{bug?: true}), do: {position, %{bug?: false, empty?: true}}

    defp convert_cell(n, position, %{empty?: true}) when n in 1..2,
      do: {position, %{bug?: true, empty?: false}}

    defp convert_cell(_, position, cell), do: {position, cell}

    defp out_cell, do: %{bug?: false, empty?: false}

    @spec next_state(grid(), (position() -> list(position)), boolean()) :: [{position, cell()}]
    def next_state(grid, adjency, middle?) do
      grid
      |> Enum.group_by(fn {{_, _, z}, _} -> z end)
      |> get_levels(middle?)
      |> Enum.flat_map(fn {_, map} -> map end)
      |> Map.new()
      |> process_flatten(adjency)
    end

    defp process_flatten(flatten, adjency) do
      flatten
      |> Enum.map(fn {position, cell} ->
        position
        |> adjency.()
        |> Enum.map(&Map.get(flatten, &1, out_cell()))
        |> Enum.count_until(& &1.bug?, 3)
        |> convert_cell(position, cell)
      end)
      |> Enum.filter(&elem(&1, 1).bug?)
    end

    @spec get_adjacents(position()) :: list(position())
    def get_adjacents({x, y, z}), do: [{x - 1, y, z}, {x + 1, y, z}, {x, y - 1, z}, {x, y + 1, z}]

    defp get_levels(levels, middle?),
      do:
        levels
        |> Map.keys()
        |> Enum.sort()
        |> Enum.min_max()
        |> then(fn {min, max} -> (min - 1)..(max + 1) end)
        |> Enum.map(fn level ->
          levels
          |> Map.get(level, [])
          |> fill(level, :level, middle?)
          |> then(fn map -> {level, map} end)
        end)

    defp fill(map, level, :level, middle?),
      do:
        {0, 0, level}
        |> Stream.iterate(fn
          {4, y, z} -> {0, y + 1, z}
          {x, y, z} -> {x + 1, y, z}
        end)
        |> Stream.transform(nil, fn
          {_, 5, _}, nil -> {:halt, nil}
          coord, nil -> {with_middle(coord, middle?), nil}
        end)
        |> Enum.reduce(Map.new(map), fn value, acc ->
          Map.put_new(acc, value, empty())
        end)

    defp empty, do: %{empty?: true, bug?: false}

    defp with_middle({2, 2, _}, false), do: []
    defp with_middle(coord, _), do: [coord]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Stream.iterate(fn grid -> Common.next_state(grid, &Common.get_adjacents/1, true) end)
      |> Stream.transform(Map.new(), fn grid, acc ->
        bio = get_biodiversity(grid)

        if Map.has_key?(acc, bio) do
          {[bio], acc}
        else
          {[], Map.put(acc, bio, :found)}
        end
      end)
      |> Enum.at(0)
    end

    defp get_biodiversity(grid) do
      grid
      |> Enum.filter(&(elem(&1, 1).bug? and elem(elem(&1, 0), 2) == 0))
      |> Enum.sum_by(fn {{x, y, 0}, _} ->
        2 ** (y * 5 + x)
      end)
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
      |> Stream.reject(fn {{x, y, _}, _} -> x == 2 and y == 2 end)
      |> Stream.iterate(fn grid -> Common.next_state(grid, &get_adjacents/1, false) end)
      |> Enum.at(200)
      |> Enum.count()
    end

    defp get_adjacents(position),
      do:
        position
        |> Common.get_adjacents()
        |> Enum.filter(fn
          {2, 2, _} -> false
          {x, y, _} -> x in 0..4 and y in 0..4
        end)
        |> Enum.concat(outer_adjacents(position))
        |> Enum.concat(inner_adjacents(position))

    defp outer_adjacents({x, y, _} = position),
      do: Enum.flat_map([x: x, y: y], &outer_adjacents(&1, position))

    defp outer_adjacents({:x, 0}, {_, _, z}), do: [{1, 2, z + 1}]
    defp outer_adjacents({:x, 4}, {_, _, z}), do: [{3, 2, z + 1}]
    defp outer_adjacents({:y, 0}, {_, _, z}), do: [{2, 1, z + 1}]
    defp outer_adjacents({:y, 4}, {_, _, z}), do: [{2, 3, z + 1}]
    defp outer_adjacents(_, _), do: []

    defp inner_adjacents({2, 1, z}), do: Enum.map(0..4, &{&1, 0, z - 1})
    defp inner_adjacents({1, 2, z}), do: Enum.map(0..4, &{0, &1, z - 1})
    defp inner_adjacents({3, 2, z}), do: Enum.map(0..4, &{4, &1, z - 1})
    defp inner_adjacents({2, 3, z}), do: Enum.map(0..4, &{&1, 4, z - 1})
    defp inner_adjacents(_), do: []
  end
end
