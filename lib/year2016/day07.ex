defmodule Aletopelta.Year2016.Day07 do
  @moduledoc """
  Day 7 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.graphemes/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&valid?/1)
    end

    defp valid?(list), do: valid?(list, false, false)

    defp valid?(["[" | rest], _, outside_abba?), do: valid?(rest, true, outside_abba?)
    defp valid?(["]" | rest], _, outside_abba?), do: valid?(rest, false, outside_abba?)

    defp valid?([a, a, a, a | rest], inside_bracket?, outside_abba?),
      do: valid?([a | rest], inside_bracket?, outside_abba?)

    defp valid?([a, b, b, a | rest], false, _), do: valid?([b, a | rest], false, true)
    defp valid?([a, b, b, a | _], true, _), do: false

    defp valid?([_ | rest], inside_bracket?, outside_abba?),
      do: valid?(rest, inside_bracket?, outside_abba?)

    defp valid?([], _, outside_abba?), do: outside_abba?
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&valid?/1)
    end

    defp valid?(list) do
      {outside, inside} = process(list)
      outside_map = Map.new(outside, &{&1, &1})

      inside
      |> Enum.uniq()
      |> Enum.any?(&is_map_key(outside_map, &1))
    end

    defp process(list), do: process(list, false, [], [])

    defp process(["[" | rest], _, outside, inside), do: process(rest, true, outside, inside)
    defp process(["]" | rest], _, outside, inside), do: process(rest, false, outside, inside)

    defp process([a, a | rest], inside_bracket?, outside, inside),
      do: process([a | rest], inside_bracket?, outside, inside)

    defp process([a, b, a | rest], false = inside_bracket?, outside, inside),
      do: process([b, a | rest], inside_bracket?, ["#{a}#{b}#{a}" | outside], inside)

    defp process([a, b, a | rest], true = inside_bracket?, outside, inside),
      do: process([b, a | rest], inside_bracket?, outside, ["#{b}#{a}#{b}" | inside])

    defp process([_ | rest], inside_bracket?, outside, inside),
      do: process(rest, inside_bracket?, outside, inside)

    defp process([], _, outside, inside), do: {outside, inside}
  end
end
