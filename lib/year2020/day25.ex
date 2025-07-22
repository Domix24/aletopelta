defmodule Aletopelta.Year2020.Day25 do
  @moduledoc """
  Day 25 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_loopsize()
      |> get_encryption()
    end

    defp find_loopsize([card, door]) do
      {1, 1}
      |> Stream.iterate(fn {i, j} ->
        {i + 1, rem(j * 7, 20_201_227)}
      end)
      |> Stream.transform(nil, fn
        {i, j}, nil when j == card -> {[{i, j}], :stop}
        _, nil -> {[], nil}
        _, :stop -> {:halt, nil}
      end)
      |> Enum.at(0)
      |> then(fn {loopsize, _} -> {loopsize, door} end)
    end

    defp get_encryption({loopsize, door}), do: get_encryption(loopsize, door, 1)

    defp get_encryption(1, _, value), do: value

    defp get_encryption(loopsize, door, value),
      do: get_encryption(loopsize - 1, door, rem(value * door, 20_201_227))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: 0
    def execute(input, []) do
      Common.parse_input(input)
      0
    end
  end
end
