defmodule Aletopelta.Year2017.Day10 do
  @moduledoc """
  Day 10 of Year 2017
  """
  alias Aletopelta.Year2017.Knot

  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: none()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Knot.raw()
      |> Enum.take(2)
      |> Enum.product()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: Knot.hash()
    def execute(input, _) do
      input
      |> Enum.at(0)
      |> Knot.parse()
      |> Knot.new()
      |> String.downcase()
    end
  end
end
