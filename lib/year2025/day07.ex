defmodule Aletopelta.Year2025.Day07 do
  @moduledoc """
  Day 7 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type tree() :: %{{integer(), integer()} => binary()}

    @spec parse_input(input()) :: tree()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, y ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn symbol, x -> {{x, y}, symbol} end)
      end)
      |> Enum.flat_map(& &1)
      |> Map.new()
    end

    @spec do_process(tree()) :: {integer(), integer()}
    def do_process(map) do
      {{x, y}, _} = Enum.find(map, &(elem(&1, 1) === "S"))

      %{map: map, split: 0, beams: [{x, y, 1}], possibilites: 0}
      |> Stream.iterate(&go_down/1)
      |> Stream.take_while(&(!Enum.empty?(&1.beams)))
      |> Enum.reduce(fn state, _ -> {state.split, state.possibilites} end)
    end

    defp go_down(%{map: map, split: split, beams: beams} = state) do
      {beams, new_split} = Enum.flat_map_reduce(beams, split, &reduce_beam(&1, &2, map))

      new_beams = group_beams(beams)
      possibilites = Enum.sum_by(new_beams, &elem(&1, 2))

      %{state | split: new_split, beams: new_beams, possibilites: possibilites}
    end

    defp reduce_beam({x, old_y, possibilites}, split, map) do
      y = old_y + 1

      case Map.get(map, {x, y}) do
        "." -> {[{x, y, possibilites}], split}
        "^" -> {[{x - 1, y, possibilites}, {x + 1, y, possibilites}], split + 1}
        nil -> {[], split}
      end
    end

    defp group_beams(beams),
      do:
        beams
        |> Enum.group_by(fn {x, y, _} -> {x, y} end, &elem(&1, 2))
        |> Enum.map(fn {{x, y}, list} -> {x, y, Enum.sum(list)} end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_process()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_process()
      |> elem(1)
    end
  end
end
