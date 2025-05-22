defmodule Aletopelta.Year2021.Day01 do
  @moduledoc """
  Day 1 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """
    @spec parse_input([binary()]) :: [number()]
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec get_increase([number()]) :: [number()]
    def get_increase([_]), do: []

    def get_increase([first, second | others]) do
      [increase(first, second) | get_increase([second | others])]
    end

    defp increase(first, second) when first < second, do: 1
    defp increase(_, _), do: 0
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute([binary()], []) :: number()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_increase()
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute([binary()], []) :: number()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
      |> Common.get_increase()
      |> Enum.sum()
    end

    defp prepare([_, _]), do: []

    defp prepare([first, second, third | others]) do
      [first + second + third | prepare([second, third | others])]
    end
  end
end
