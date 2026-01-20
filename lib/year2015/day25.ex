defmodule Aletopelta.Year2015.Day25 do
  @moduledoc """
  Day 25 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.flat_map(input, fn line ->
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> prepare()
    end

    defp prepare([row, column]), do: loop(row, column)

    defp loop(row, column) do
      {{40, 6016}, 6_053_589}
      |> Stream.iterate(fn {coord, value} ->
        {update(coord), rem(value * 252_533, 33_554_393)}
      end)
      |> Enum.find_value(fn
        {{^column, ^row}, value} -> value
        _ -> false
      end)
    end

    defp update({x, 1}), do: {1, x + 1}
    defp update({x, y}), do: {x + 1, y - 1}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      Common.parse_input(input)
      0
    end
  end
end
