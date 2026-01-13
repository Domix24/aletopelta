defmodule Aletopelta.Year2015.Day03 do
  @moduledoc """
  Day 3 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type direction() :: {integer(), integer()}

    @spec parse_input(input()) :: list(direction())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&to_direction/1)
    end

    defp to_direction("^"), do: {0, -1}
    defp to_direction("v"), do: {0, 1}
    defp to_direction(">"), do: {1, 0}
    defp to_direction("<"), do: {-1, 0}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce({Map.new([{{0, 0}, 1}]), {0, 0}}, fn {dx, dy}, {visited, {x, y}} ->
        new_position = {x + dx, y + dy}
        new_visited = Map.put(visited, new_position, 1)

        {new_visited, new_position}
      end)
      |> elem(0)
      |> Enum.count()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.with_index()
      |> Enum.reduce({Map.new([{{0, 0}, 1}]), {{0, 0}, {0, 0}}}, fn direction,
                                                                    {visited, positions} ->
        {updated, new_positions} = adjust(direction, positions)

        new_visited = Map.put(visited, updated, 1)

        {new_visited, new_positions}
      end)
      |> elem(0)
      |> Enum.count()
    end

    defp adjust({{dx, dy}, index}, {{x, y}, robo}) when rem(index, 2) < 1,
      do: {{x + dx, y + dy}, {{x + dx, y + dy}, robo}}

    defp adjust({{dx, dy}, _}, {santa, {x, y}}), do: {{x + dx, y + dy}, {santa, {x + dx, y + dy}}}
  end
end
