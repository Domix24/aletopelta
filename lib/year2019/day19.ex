defmodule Aletopelta.Year2019.Day19 do
  @moduledoc """
  Day 19 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec prepare(Intcode.intcode(), {integer(), integer()}) ::
            {Intcode.memory(), Intcode.output(), Intcode.state()}
    def prepare(map, {x, y}), do: Intcode.prepare(map, [x, y])

    @spec beam?({integer(), integer()}, Intcode.intcode()) :: boolean()
    def beam?(input, intcode),
      do:
        intcode
        |> prepare(input)
        |> elem(1)
        |> Kernel.===([1])
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> build_grid()
      |> Enum.sum_by(&get_size/1)
    end

    defp get_size({_, range}), do: Range.size(range)

    defp build_grid(intcode, square \\ 50) do
      Stream.transform(0..(square - 1), {-1, 0}, fn x, {last_min, last_size} = last_acc ->
        (last_min + 1)
        |> Range.new(min(last_min + 4, square - 1), 1)
        |> Enum.find(&Common.beam?({x, &1}, intcode))
        |> process_grid(last_size, square, x, last_acc, intcode)
      end)
    end

    defp process_grid(nil, _, _, _, acc, _), do: {[], acc}

    defp process_grid(min, nil, square, x, _, _) when is_integer(min),
      do: process_max(nil, min, square, x)

    defp process_grid(mim, size, square, x, _, intcode) when is_integer(mim),
      do:
        mim
        |> Range.new(min(mim + size + 1, square - 1))
        |> Enum.find(&(!Common.beam?({x, &1}, intcode)))
        |> process_max(mim, square, x)

    defp process_grid(_, _, _, x, _, _) when x > 2, do: {:halt, nil}
    defp process_grid(_, _, _, _, acc, _), do: {[], acc}

    defp process_max(nil, new_min, square, x),
      do: {[{x, Range.new(new_min, square - 1)}], {new_min, nil}}

    defp process_max(new_max, new_min, _, x),
      do: {[{x, Range.new(new_min, new_max - 1)}], {new_min, new_max - new_min}}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_ship()
      |> then(fn {x, y} -> x * 10_000 + y end)
    end

    defp find_ship(intcode, start \\ {900, 1400}, size \\ 100),
      do:
        intcode
        |> get_rows(start)
        |> Enum.find_value(fn {x, y} -> ship?({x, y}, size, intcode) end)

    defp ship?(position, size, intcode),
      do:
        position
        |> build_corners(size)
        |> Enum.take(2)
        |> Enum.all?(&Common.beam?(&1, intcode))
        |> topleft(position, size)

    defp build_corners({x, y}, size),
      do: [{x + size - 1, y}, {x + size - 1, y - size + 1}, {x, y - size + 1}]

    defp topleft(false, _, _), do: false

    defp topleft(true, position, size),
      do:
        position
        |> build_corners(size)
        |> Enum.at(2)

    defp get_rows(intcode, {_, size} = start),
      do:
        start
        |> get_row(intcode)
        |> then(fn x -> {x, size} end)
        |> Stream.iterate(fn {x, y} ->
          new_x = get_row({x, y + 1}, intcode)
          {new_x, y + 1}
        end)

    defp get_row({x, y}, intcode),
      do:
        x
        |> Stream.iterate(&(&1 + 1))
        |> Enum.find(fn sx -> Common.beam?({sx, y}, intcode) end)
  end
end
