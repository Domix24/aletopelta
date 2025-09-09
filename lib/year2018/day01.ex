defmodule Aletopelta.Year2018.Day01 do
  @moduledoc """
  Day 1 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.join()
      |> then(fn line ->
        ~r"-?\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
      end)
      |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Stream.cycle()
      |> Stream.transform(0, &{[&1 + &2], &1 + &2})
      |> Stream.transform(Map.new(), fn
        frequency, map when is_map_key(map, frequency) -> {[frequency], map}
        frequency, map -> {[], Map.put(map, frequency, 1)}
      end)
      |> Enum.at(0)
    end
  end
end
