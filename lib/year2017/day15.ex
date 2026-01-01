defmodule Aletopelta.Year2017.Day15 do
  @moduledoc """
  Day 15 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: {integer(), integer()}
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        ~r"(\d+)"
        |> Regex.run(line)
        |> Enum.at(0)
        |> String.to_integer()
      end)
      |> format()
    end

    defp format([gena, genb]), do: {gena, genb}

    @spec do_loop({integer(), integer()}, {integer(), integer()}, integer()) :: integer()
    def do_loop({gena, genb}, {moda, modb}, total),
      do:
        1..total
        |> Enum.reduce({gena, genb, 0}, fn _, {acc_gena, acc_genb, acc_count} ->
          final_gena = generate(acc_gena, 16_807, moda)
          final_genb = generate(acc_genb, 48_271, modb)

          [state_gena, state_genb] = Enum.map([final_gena, final_genb], &Bitwise.band(&1, 0xFFFF))

          {final_gena, final_genb, acc_count + convert(state_gena === state_genb)}
        end)
        |> elem(2)

    defp convert(true), do: 1
    defp convert(false), do: 0

    defp generate(number, factor, mod),
      do:
        number
        |> iterate(factor)
        |> stream(factor, mod)

    defp iterate(number, factor), do: rem(number * factor, 2_147_483_647)
    defp stream(value, _, 1), do: value
    defp stream(value, _, mod) when rem(value, mod) < 1, do: value

    defp stream(value, factor, mod),
      do:
        value
        |> iterate(factor)
        |> stream(factor, mod)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop({1, 1}, 40_000_000)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop({4, 8}, 5_000_000)
    end
  end
end
