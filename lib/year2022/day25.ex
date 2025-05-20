defmodule Aletopelta.Year2022.Day25 do
  @moduledoc """
  Day 25 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """
    @spec parse_input([binary()]) :: [binary()]
    def parse_input(input) do
      input
    end

    @spec to_decimal(binary()) :: integer()
    def to_decimal(source) do
      source
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.with_index(fn digit, power ->
        value =
          case digit do
            "=" -> -2
            "-" -> -1
            "0" -> 0
            "1" -> 1
            "2" -> 2
          end

        value * 5 ** power
      end)
      |> Enum.sum()
      |> trunc()
    end

    @spec to_snafu(integer()) :: binary()
    def to_snafu(source) do
      source
      |> do_snafu([])
      |> Enum.join()
    end

    defp do_snafu(0, []), do: ["0"]
    defp do_snafu(0, acc), do: acc

    defp do_snafu(number, acc) do
      remainder = rem(number, 5)
      quotient = div(number, 5)

      {digit, carry} =
        case remainder do
          -2 -> {"=", 0}
          -1 -> {"-", 0}
          0 -> {"0", 0}
          1 -> {"1", 0}
          2 -> {"2", 0}
          3 -> {"=", 1}
          4 -> {"-", 1}
        end

      do_snafu(quotient + carry, [digit | acc])
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    @spec execute([binary()]) :: binary()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&Common.to_decimal/1)
      |> Common.to_snafu()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute([binary()]) :: 0
    def execute(input) do
      Common.parse_input(input)
      0
    end
  end
end
