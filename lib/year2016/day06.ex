defmodule Aletopelta.Year2016.Day06 do
  @moduledoc """
  Day 6 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())
    @type output() :: binary()

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.graphemes/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.zip_with(& &1)
      |> Enum.map_join(fn line ->
        line
        |> Enum.frequencies()
        |> Enum.max_by(&elem(&1, 1))
        |> elem(0)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.zip_with(& &1)
      |> Enum.map_join(fn line ->
        line
        |> Enum.frequencies()
        |> Enum.min_by(&elem(&1, 1))
        |> elem(0)
      end)
    end
  end
end
