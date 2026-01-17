defmodule Aletopelta.Year2015.Day08 do
  @moduledoc """
  Day 8 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: input()
    def parse_input(input) do
      input
    end

    @spec traverse(input) :: list({integer(), integer(), integer()})
    def traverse(input), do: Enum.map(input, &subtraverse/1)

    defp subtraverse(<<"\"", rest::binary>>) do
      {code, memory, encode} = subtraverse(rest)
      {1 + code, memory, 3 + encode}
    end

    defp subtraverse(<<"\\x", _::binary-size(2), rest::binary>>) do
      {code, memory, encode} = subtraverse(rest)
      {4 + code, 1 + memory, 5 + encode}
    end

    defp subtraverse(<<"\\", _, rest::binary>>) do
      {code, memory, encode} = subtraverse(rest)
      {2 + code, 1 + memory, 4 + encode}
    end

    defp subtraverse(<<_, rest::binary>>) do
      {code, memory, encode} = subtraverse(rest)
      {1 + code, 1 + memory, 1 + encode}
    end

    defp subtraverse(""), do: {0, 0, 0}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> Enum.sum_by(&points/1)
    end

    defp points({code, memory, _}), do: code - memory
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> Enum.sum_by(&points/1)
    end

    defp points({code, _, encode}), do: encode - code
  end
end
