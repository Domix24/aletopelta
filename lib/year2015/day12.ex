defmodule Aletopelta.Year2015.Day12 do
  @moduledoc """
  Day 12 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: term()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> JSON.decode!()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> traverse()
    end

    defp traverse([_ | _] = list), do: Enum.sum_by(list, &traverse/1)
    defp traverse(binary) when is_binary(binary), do: 0
    defp traverse(integer) when is_integer(integer), do: integer

    defp traverse(map) when is_map(map),
      do:
        map
        |> Map.values()
        |> Enum.sum_by(&traverse/1)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> traverse()
    end

    defp traverse([_ | _] = list), do: Enum.sum_by(list, &traverse/1)
    defp traverse(binary) when is_binary(binary), do: 0
    defp traverse(integer) when is_integer(integer), do: integer

    defp traverse(map) when is_map(map),
      do:
        map
        |> Map.values()
        |> handle_red()
        |> Enum.sum_by(&traverse/1)

    defp handle_red(values),
      do:
        values
        |> Enum.find(&(&1 === "red"))
        |> prepare(values)

    defp prepare(nil, values), do: values
    defp prepare(_, _), do: []
  end
end
