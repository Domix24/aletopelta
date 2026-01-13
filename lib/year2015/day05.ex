defmodule Aletopelta.Year2015.Day05 do
  @moduledoc """
  Day 5 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: input()
    def parse_input(input) do
      input
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&nice?/1)
    end

    defp nice?(string), do: vowels?(string) and duplicate?(string) and valid?(string)

    defp vowels?(string),
      do:
        ~r"[aeiou]"
        |> Regex.scan(string)
        |> Enum.count()
        |> vowels?(:count)

    defp vowels?(count, :count), do: count > 2

    defp duplicate?(string),
      do:
        ~r"(\w)\1"
        |> Regex.scan(string)
        |> Enum.count()
        |> duplicate?(:count)

    defp duplicate?(count, :count), do: count > 0

    defp valid?(string),
      do:
        ~r"ab|cd|pq|xy"
        |> Regex.scan(string)
        |> Enum.count()
        |> valid?(:count)

    defp valid?(count, :count), do: count < 1
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&nice?/1)
    end

    defp nice?(string), do: pairs?(string) and repeats?(string)

    defp pairs?(string),
      do:
        ~r"(\w\w).*\1"
        |> Regex.scan(string)
        |> Enum.count()
        |> pairs?(:count)

    defp pairs?(count, :count), do: count > 0

    defp repeats?(string),
      do:
        ~r"(\w).\1"
        |> Regex.scan(string)
        |> Enum.count()
        |> repeats?(:count)

    defp repeats?(count, :count), do: count > 0
  end
end
