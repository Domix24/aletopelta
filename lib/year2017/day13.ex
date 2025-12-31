defmodule Aletopelta.Year2017.Day13 do
  @moduledoc """
  Day 13 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list({integer(), integer()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [depth, range] =
          line
          |> String.split(": ")
          |> Enum.map(&String.to_integer/1)

        {depth, range}
      end)
    end

    @spec move(list({integer(), integer()}), integer(), integer()) :: list({integer(), integer()})
    def move([], _, _), do: []

    def move([{pico, range} | firewall], pico, delay) do
      if rrem(pico + delay, range - 1) === 0 do
        [{pico, range} | move(firewall, pico + 1, delay)]
      else
        move(firewall, pico + 1, delay)
      end
    end

    def move(firewall, pico, delay), do: move(firewall, pico + 1, delay)

    defp rrem(i, mod), do: mod - abs(rem(i, mod * 2) - mod)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.move(0, 0)
      |> Enum.sum_by(fn {a, b} -> a * b end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> find_smallest()
    end

    defp find_smallest(firewall),
      do:
        3_850_000
        |> Stream.iterate(&(&1 + 1))
        |> Enum.find(&handle(firewall, 0, &1))

    defp handle(firewall, pico, delay) do
      case Common.move(firewall, pico, delay) do
        [] -> true
        _ -> false
      end
    end
  end
end
