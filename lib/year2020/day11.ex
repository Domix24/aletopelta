defmodule Aletopelta.Year2020.Day11 do
  @moduledoc """
  Day 11 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type seating() :: %{{integer(), integer()} => :floor | :empty | :occupied}

    @spec parse_input(input()) :: seating()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(&{{&2, y}, to_atom(&1)})
      end)
      |> Map.new()
    end

    defp to_atom("."), do: :floor
    defp to_atom("L"), do: :empty
    defp to_atom("#"), do: :occupied

    @spec prepare_loop(seating(), keyword()) :: seating()
    def prepare_loop(seating, opts) do
      do_loop(seating, opts)
    end

    defp do_loop(seating, opts) do
      seating
      |> Enum.map(& &1)
      |> move(seating, false, opts)
      |> continue_loop(opts)
    end

    defp continue_loop({seats, true}, opts),
      do:
        seats
        |> Map.new()
        |> do_loop(opts)

    defp continue_loop({seats, false}, _), do: Map.new(seats)

    defp move([], _, state, _) do
      {[], state}
    end

    defp move([{position, :occupied} | seats], seating, state, opts) do
      position
      |> get_adjacents({opts[:adjacents], seating})
      |> Enum.count(&(Map.get(seating, &1, :floor) == :occupied))
      |> decide(:occupied, position, state, opts)
      |> continue(seats, seating, opts)
    end

    defp move([{position, :empty} | seats], seating, state, opts) do
      position
      |> get_adjacents({opts[:adjacents], seating})
      |> Enum.count(&(Map.get(seating, &1, :floor) == :occupied))
      |> decide(:empty, position, state, opts)
      |> continue(seats, seating, opts)
    end

    defp move([seat | seats], seating, state, opts) do
      continue({seat, state}, seats, seating, opts)
    end

    defp decide(n, :occupied, position, state, opts),
      do: decide_occupied(n, position, state, opts[:limit])

    defp decide(0, :empty, position, _, _), do: {{position, :occupied}, true}
    defp decide(_, :empty, position, state, _), do: {{position, :empty}, state}

    defp decide_occupied(n, position, _, limit) when n > limit, do: {{position, :empty}, true}
    defp decide_occupied(_, position, state, _), do: {{position, :occupied}, state}

    defp continue({new_seat, alt_state}, seats, seating, opts) do
      {new_seats, new_state} = move(seats, seating, alt_state, opts)
      {[new_seat | new_seats], new_state}
    end

    defp get_adjacents(pos, {nil, _}), do: adjacents(pos)
    defp get_adjacents(pos, {func, grid}), do: func.(pos, grid)

    defp adjacents({x, y}),
      do: [
        {x - 1, y - 1},
        {x - 0, y - 1},
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
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop(limit: 3)
      |> Enum.count(&(elem(&1, 1) == :occupied))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop(limit: 4, adjacents: &get_visible/2)
      |> Enum.count(&(elem(&1, 1) == :occupied))
    end

    defp adjacents, do: [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

    defp get_visible({x, y}, grid) do
      adjacents()
      |> Enum.flat_map(fn delta ->
        get_point({x, y}, delta, grid)
      end)
      |> before_visible(grid)
    end

    defp get_visible([_ | _] = coords, grid) do
      coords
      |> Enum.flat_map(fn
        {delta, position, false} -> get_point(position, delta, grid)
        value -> [value]
      end)
      |> before_visible(grid)
    end

    defp get_point({x, y}, {dx, dy} = delta, grid) do
      new_position = {x + dx, y + dy}
      cell = Map.get(grid, new_position, :out)

      if cell == :out do
        []
      else
        [{delta, new_position, cell != :floor}]
      end
    end

    defp before_visible(list, grid) do
      if Enum.all?(list, &elem(&1, 2)) do
        Enum.map(list, &elem(&1, 1))
      else
        get_visible(list, grid)
      end
    end
  end
end
