defmodule Aletopelta.Year2020.Day02 do
  @moduledoc """
  Day 2 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list({Range.t(), binary(), binary()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [[_, omin, omax, letter, password]] = Regex.scan(~r/(\d+)-(\d+) ([a-z]): ([a-z]+)/, line)

        [min, max] = Enum.map([omin, omax], &String.to_integer/1)
        {Range.new(min, max), letter, password}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.count(&valid?/1)
    end

    defp valid?({range, letter, password}) do
      password
      |> String.graphemes()
      |> Enum.reduce_while(0, fn
        _, acc when acc > range.last -> {:halt, acc}
        ^letter, acc -> {:cont, acc + 1}
        _, acc -> {:cont, acc}
      end)
      |> Kernel.in(range)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.count(&valid?/1)
    end

    defp valid?({range, letter, password}) do
      {valid1, rest} = valid(range.first, letter, password, 1)
      {valid2, _} = valid(range.last, letter, rest, range.first + 1)

      [valid1, valid2]
      |> Enum.count(& &1)
      |> Kernel.==(1)
    end

    defp valid(destination, letter, <<letter2, rest::binary>>, destination) do
      {letter == <<letter2>>, rest}
    end

    defp valid(destination, letter, <<_, rest::binary>>, index) do
      valid(destination, letter, rest, index + 1)
    end
  end
end
