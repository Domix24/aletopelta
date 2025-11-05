defmodule Aletopelta.Year2018.Day25 do
  @moduledoc """
  Day 25 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(integer()))
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"-?\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)
      end)
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
      |> do_part()
    end

    defp do_part([]), do: 0

    defp do_part([point | old_rest]) do
      rest =
        {[point], old_rest}
        |> Stream.iterate(fn {[point | next_points], rest} ->
          {in_constellation, out_constellation} =
            Enum.split_with(rest, &(distance(point, &1) < 4))

          {next_points ++ in_constellation, out_constellation}
        end)
        |> Enum.find(&empty?/1)
        |> elem(1)

      1 + do_part(rest)
    end

    defp distance(points1, points2),
      do:
        Enum.zip_reduce(points1, points2, 0, fn point1, point2, acc ->
          abs(point2 - point1) + acc
        end)

    defp empty?({list, _}), do: Enum.empty?(list)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: 0
    def execute(input, _) do
      Common.parse_input(input)
      0
    end
  end
end
