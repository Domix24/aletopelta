defmodule Aletopelta.Year2020.Day06 do
  @moduledoc """
  Day 6 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&count_questions/1)
    end

    defp count_questions(people) do
      people
      |> Enum.join("")
      |> String.graphemes()
      |> Enum.uniq()
      |> length()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&count_allyes/1)
    end

    defp count_allyes(people) do
      nb_people = length(people)

      people
      |> Enum.join("")
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.filter(&(elem(&1, 1) == nb_people))
      |> length()
    end
  end
end
