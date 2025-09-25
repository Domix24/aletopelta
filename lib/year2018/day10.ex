defmodule Aletopelta.Year2018.Day10 do
  @moduledoc """
  Day 10 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type state() :: list({integer(), integer(), integer(), integer()})

    @spec parse_input(input()) :: state()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [position_x, position_y, velocity_x, velocity_y] =
          ~r"-?\d+"
          |> Regex.scan(line)
          |> Enum.map(fn [number] -> String.to_integer(number) end)

        {{position_x, position_y}, {velocity_x, velocity_y}}
      end)
    end

    @spec do_loop(state()) :: {list(binary()), integer(), integer(), integer()}
    def do_loop(state) do
      state
      |> Stream.iterate(fn state ->
        Enum.map(state, fn {{px, py}, {vx, vy} = v} -> {{px + vx, py + vy}, v} end)
      end)
      |> Stream.with_index()
      |> Enum.reduce_while(nil, fn {list, seconds}, acc ->
        reduce(list, seconds, acc)
      end)
    end

    defp reduce(list, seconds, acc) do
      {{{minx, _}, _}, {{maxx, _}, _}} = Enum.min_max_by(list, fn {{x, _}, _} -> x end)
      newdiff = maxx - minx

      if acc === nil do
        {:cont, {newdiff, list, seconds, minx, maxx}}
      else
        {olddiff, oldlist, oldseconds, oldminx, oldmaxx} = acc

        if newdiff < olddiff do
          {:cont, {newdiff, list, seconds, minx, maxx}}
        else
          {:halt, {oldlist, oldseconds, oldminx, oldmaxx}}
        end
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: list(binary())
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_loop()
      |> show()
    end

    defp show({list, _, min_x, max_x}) do
      positions = Enum.group_by(list, &elem(&1, 0))
      {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(list, fn {{_, y}, _} -> y end)

      for y <- min_y..max_y do
        for x <- min_x..max_x, into: "" do
          show(positions, {x, y})
        end
      end
    end

    defp show(positions, position) when is_map_key(positions, position), do: "X"
    defp show(_, _), do: "."
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_loop()
      |> elem(1)
    end
  end
end
