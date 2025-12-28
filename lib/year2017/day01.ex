defmodule Aletopelta.Year2017.Day01 do
  @moduledoc """
  Day 1 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> start()
    end

    defp start([first | _] = complete), do: start(complete, first)
    defp start([number, number | rest], first), do: number + start([number | rest], first)
    defp start([number], number), do: number
    defp start([], _), do: 0
    defp start([_ | rest], number), do: start(rest, number)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> prepare()
    end

    defp prepare(list) do
      size = Enum.count(list)
      halfway = div(size, 2)
      halflist = Enum.take(list, halfway)

      start(list, halflist, halfway - 1)
    end

    defp start([], _, _), do: 0

    defp start([number | rest], half, halfway) do
      sum =
        case Enum.at(rest ++ half, halfway) do
          ^number -> number
          _ -> 0
        end

      sum + start(rest, half, halfway)
    end
  end
end
