defmodule Aletopelta.Year2018.Day05 do
  @moduledoc """
  Day 5 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_charlist()
    end

    defguardp is_reactive(first, second) when abs(first - second) === ?z - ?Z

    @spec react?(integer(), integer()) :: boolean()
    def react?(first, second) when is_reactive(first, second), do: true
    def react?(_, _), do: false

    defp react([]), do: []

    defp react([first | rest]) do
      case react(rest) do
        [] -> [first]
        [second | rest] -> react(first, second) ++ rest
      end
    end

    defp react(first, second) when is_reactive(first, second), do: []
    defp react(first, second), do: [first, second]

    @spec do_react(list(integer())) :: integer()
    def do_react(polymer),
      do:
        polymer
        |> react()
        |> Enum.count()
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_react()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> process_input()
      |> Enum.min()
    end

    defp process_input(parsed) do
      parsed
      |> Stream.flat_map(fn poly ->
        [poly]
        |> String.Chars.to_string()
        |> String.downcase()
        |> String.to_charlist()
      end)
      |> Stream.uniq()
      |> Stream.map(fn unit ->
        parsed
        |> Stream.reject(&react?(&1, unit))
        |> Enum.to_list()
        |> Common.do_react()
      end)
    end

    defp react?(first, first), do: true
    defp react?(first, second), do: Common.react?(first, second)
  end
end
