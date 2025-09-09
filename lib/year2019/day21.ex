defmodule Aletopelta.Year2019.Day21 do
  @moduledoc """
  Day 21 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec run(Intcode.intcode(), binary()) :: integer()
    def run(intcode, input) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.to_charlist(&1) ++ ~c"\n"))
      |> Enum.concat()
      |> set_input(intcode)
    end

    defp set_input(input, intcode) do
      intcode
      |> Intcode.prepare(input)
      |> elem(1)
      |> Enum.reverse()
      |> prepare_show()
      |> show()
    end

    defp prepare_show(result), do: {result, Enum.find(result, &(&1 > 117))}

    defp show({_, nil}), do: 0
    defp show({_, result}), do: result
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.run(~s"""
      NOT C J
      AND D J
      NOT A T
      OR T J
      WALK
      """)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.run(~s"""
      NOT C J
      AND D J
      AND H J
      NOT B T
      AND D T
      OR T J
      NOT A T
      OR T J
      RUN
      """)
    end
  end
end
