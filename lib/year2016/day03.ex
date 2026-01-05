defmodule Aletopelta.Year2016.Day03 do
  @moduledoc """
  Day 3 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type triangle() :: list(integer())

    @spec parse_input(input()) :: list(triangle())
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)
      end)
    end

    @spec triangle?(triangle()) :: boolean()
    def triangle?([a, b, c]), do: a + b > c and a + c > b and b + c > a
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&Common.triangle?/1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.chunk_every(3)
      |> Enum.flat_map(fn chunk -> Enum.zip_with(chunk, & &1) end)
      |> Enum.count(&Common.triangle?/1)
    end
  end
end
