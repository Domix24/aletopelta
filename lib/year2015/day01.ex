defmodule Aletopelta.Year2015.Day01 do
  @moduledoc """
  Day 1 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(binary())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.frequencies()
      |> handle()
    end

    defp handle(frequencies) do
      up_count = Map.fetch!(frequencies, "(")
      down_count = Map.fetch!(frequencies, ")")
      up_count - down_count
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.with_index()
      |> Enum.reduce_while(0, fn
        {"(", _}, level -> {:cont, level + 1}
        {")", index}, 0 -> {:halt, index + 1}
        _, level -> {:cont, level - 1}
      end)
    end
  end
end
