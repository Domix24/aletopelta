defmodule Aletopelta.Year2019.Day01 do
  @moduledoc """
  Day 1 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())
    @type mass() :: integer()
    @type fuel() :: integer()

    @spec parse_input(input()) :: list(mass())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec get_fuel(mass()) :: fuel()
    def get_fuel(mass),
      do:
        mass
        |> div(3)
        |> floor()
        |> Kernel.-(2)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&Common.get_fuel/1)
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
      |> Enum.flat_map(&get_requirements/1)
      |> Enum.sum()
    end

    defp get_requirements(mass, list \\ []),
      do:
        mass
        |> Common.get_fuel()
        |> continue_requirements(list)

    defp continue_requirements(fuel, list) when fuel < 1, do: list
    defp continue_requirements(fuel, list), do: get_requirements(fuel, [fuel | list])
  end
end
