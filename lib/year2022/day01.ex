defmodule Aletopelta.Year2022.Day01 do
  @moduledoc """
  Day 1 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """
    @spec parse_input(any()) :: nonempty_list()
    def parse_input(input) do
      {total, current} =
        Enum.reduce(input, {[], []}, fn
          "", {acc, cur} ->
            {[cur | acc], []}

          calorie, {acc, cur} ->
            {acc, [String.to_integer(calorie) | cur]}
        end)

      [current | total]
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(any()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.max_by(&Enum.sum/1)
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(any()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.sort_by(&Enum.sum/1, :desc)
      |> Enum.take(3)
      |> Enum.sum_by(&Enum.sum/1)
    end
  end
end
