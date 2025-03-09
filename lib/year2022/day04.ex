defmodule Aletopelta.Year2022.Day04 do
  @moduledoc """
  Day 4 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """
    @spec parse_input(any()) :: list()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [first_r1, last_r1, first_r2, last_r2] =
          line
          |> String.split([",", "-"])
          |> Enum.map(&String.to_integer/1)

        {first_r1..last_r1//1, first_r2..last_r2//1}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.count(&covers?/1)
    end

    defp covers?({range1, range2})
         when range1.first <= range2.first and range1.last >= range2.last,
         do: true

    defp covers?({range1, range2})
         when range2.first <= range1.first and range2.last >= range1.last,
         do: true

    defp covers?(_), do: false
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.count(&overlaps?/1)
    end

    defp overlaps?({range1, range2}), do: !Range.disjoint?(range1, range2)
  end
end
