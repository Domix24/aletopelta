defmodule Aletopelta.Year2018.Day03 do
  @moduledoc """
  Day 3 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: %{{integer(), integer()} => list({integer(), integer()})}
    def parse_input(input) do
      input
      |> Map.new(fn line ->
        ~r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)"
        |> Regex.run(line, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)
        |> then(fn [id, x, y, width, height] ->
          {id, %{id: id, position: {x, y}, height: height, width: width, size: height * width}}
        end)
      end)
      |> Enum.reduce(Map.new(), &build_map/2)
    end

    defp build_map({_, %{position: {px, py}} = claim}, acc) do
      Enum.reduce(px..(px + claim.width - 1), acc, fn x, acc ->
        Enum.reduce(py..(py + claim.height - 1), acc, fn y, acc ->
          Map.update(acc, {x, y}, [{claim.id, claim.size}], &[{claim.id, claim.size} | &1])
        end)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.count(fn
        {_, [_, _ | _]} -> true
        _ -> false
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.filter(fn
        {_, [_]} -> true
        _ -> false
      end)
      |> Enum.frequencies_by(fn {_, [claim]} -> claim end)
      |> Enum.find(fn {{_, size}, count} -> size === count end)
      |> then(fn {{id, _}, _} -> id end)
    end
  end
end
