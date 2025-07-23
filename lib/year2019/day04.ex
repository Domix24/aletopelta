defmodule Aletopelta.Year2019.Day04 do
  @moduledoc """
  Day 4 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
    end

    @spec all_increase?(integer()) :: boolean()
    def all_increase?(number),
      do:
        "#{number}"
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
        |> all_increase?(:priv)

    defp all_increase?([n1, n2 | _], _) when n1 > n2, do: false
    defp all_increase?([_, n2 | rest], atom), do: all_increase?([n2 | rest], atom)
    defp all_increase?(_, _), do: true
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> generate_numbers()
      |> Enum.count()
    end

    defp generate_numbers([low, high]),
      do:
        low..high//1
        |> Stream.filter(&Common.all_increase?/1)
        |> Stream.filter(&with_duplicate?/1)

    defp with_duplicate?(number),
      do:
        "#{number}"
        |> String.graphemes()
        |> Enum.frequencies()
        |> Enum.any?(&(elem(&1, 1) > 1))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> generate_numbers()
      |> Enum.count()
    end

    defp generate_numbers([low, high]),
      do:
        low..high//1
        |> Stream.filter(&Common.all_increase?/1)
        |> Stream.filter(&only_two?/1)

    defp only_two?(number),
      do:
        "#{number}"
        |> String.graphemes()
        |> Enum.frequencies()
        |> Enum.any?(&(elem(&1, 1) == 2))
  end
end
