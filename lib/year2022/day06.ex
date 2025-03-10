defmodule Aletopelta.Year2022.Day06 do
  @moduledoc """
  Day 6 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """
    @spec parse_input(any()) :: nil
    def parse_input(_) do
    end

    @spec find_marker(binary(), non_neg_integer()) :: non_neg_integer()
    def find_marker(line, maximum) do
      find_marker(line, [], 0, maximum, 0)
    end

    defp find_marker(_, _, maximum, maximum, index) do
      index
    end

    defp find_marker(
           <<character::utf8, remaining::binary>>,
           uniques,
           count_uniques,
           maximum,
           index
         ) do
      {updated_uniques, updated_count} =
        case Enum.find_index(uniques, &(&1 == <<character>>)) do
          nil ->
            updated_uniques = [<<character>> | uniques]
            updated_count = count_uniques + 1

            {updated_uniques, updated_count}

          found_index ->
            updated_uniques = [<<character>> | Enum.take(uniques, found_index)]
            updated_count = found_index + 1

            {updated_uniques, updated_count}
        end

      find_marker(remaining, updated_uniques, updated_count, maximum, index + 1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(any()) :: number()
    def execute(input) do
      Enum.sum_by(input, fn line ->
        Common.find_marker(line, 4)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(any()) :: number()
    def execute(input) do
      Enum.sum_by(input, fn line ->
        Common.find_marker(line, 14)
      end)
    end
  end
end
