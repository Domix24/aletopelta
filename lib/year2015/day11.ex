defmodule Aletopelta.Year2015.Day11 do
  @moduledoc """
  Day 11 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type output() :: binary()
    @type password() :: list(integer())

    @spec parse_input(input()) :: password()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_charlist()
    end

    @spec find_next(password(), integer()) :: output()
    def find_next(password, index),
      do:
        password
        |> Stream.iterate(&next/1)
        |> Stream.filter(&valid?/1)
        |> Enum.at(index)
        |> to_string()

    defp next(password),
      do:
        password
        |> Enum.reverse()
        |> increase()
        |> Enum.reverse()

    defp increase([letter | rest]) when letter > ?y, do: [?a | increase(rest)]
    defp increase([letter | rest]), do: [letter + 1 | rest]

    defp valid?(password),
      do: increasing?(password, 0) and characters?(password) and pairs?(password, nil)

    defp increasing?(_, 2), do: true
    defp increasing?([], _), do: false

    defp increasing?([letter1, letter2 | rest], since) when letter1 + 1 == letter2,
      do: increasing?([letter2 | rest], since + 1)

    defp increasing?([_ | rest], _), do: increasing?(rest, 0)

    defp characters?([]), do: true
    defp characters?([characters | _]) when characters in [?i, ?o, ?l], do: false
    defp characters?([_ | rest]), do: characters?(rest)

    defp pairs?(_, {_, _}), do: true
    defp pairs?([], _), do: false
    defp pairs?([letter, letter | rest], nil), do: pairs?(rest, letter)
    defp pairs?([letter | rest], letter), do: pairs?(rest, letter)
    defp pairs?([letter1, letter1 | rest], letter2), do: pairs?(rest, {letter1, letter2})
    defp pairs?([_ | rest], pairs), do: pairs?(rest, pairs)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_next(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_next(1)
    end
  end
end
