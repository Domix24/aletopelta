defmodule Aletopelta.Year2019.Day09 do
  @moduledoc """
  Day 9 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Intcode.prepare([1])
      |> elem(1)
      |> Enum.at(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Intcode.prepare([2])
      |> elem(1)
      |> Enum.at(0)
    end
  end
end
