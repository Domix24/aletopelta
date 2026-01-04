defmodule Aletopelta.Year2016.Day02 do
  @moduledoc """
  Day 2 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())
    @type output() :: binary()
    @type directions() :: list(list(movement()))
    @type movement() :: :R | :D | :L | :U
    @type position() :: {integer(), integer()}

    @spec parse_input(input()) :: directions()
    def parse_input(input) do
      Enum.map(input, fn line ->
        new_line =
          line
          |> String.graphemes()
          |> Enum.join(" ")

        ~w"#{new_line}"a
      end)
    end

    @spec map_reduce(directions(), (position(), position() -> position())) :: list(position())
    def map_reduce(all_directions, adjust) do
      all_directions
      |> Enum.map_reduce({0, 0}, fn directions, last ->
        position =
          Enum.reduce(directions, last, fn direction, position ->
            position
            |> move(direction)
            |> adjust.(position)
          end)

        {position, position}
      end)
      |> elem(0)
    end

    defp move({x, y}, :U), do: {x, y - 1}
    defp move({x, y}, :D), do: {x, y + 1}
    defp move({x, y}, :L), do: {x - 1, y}
    defp move({x, y}, :R), do: {x + 1, y}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.map_reduce(&adjust/2)
      |> Enum.map_join(&numpad/1)
    end

    defp adjust({x, y} = position, _) when x in -1..1 and y in -1..1, do: position
    defp adjust(_, position), do: position

    defp numpad({-1, 1}), do: 7
    defp numpad({0, 1}), do: 8
    defp numpad({0, -1}), do: 2
    defp numpad({1, 1}), do: 9
    defp numpad({1, -1}), do: 3
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.map_reduce(&adjust/2)
      |> Enum.map_join(&numpad/1)
    end

    defp adjust({x, 0} = position, _) when x in 0..4//4, do: position
    defp adjust({x, y} = position, _) when x in 1..3//2 and y in -1..1, do: position
    defp adjust({2, y} = position, _) when y in -2..2, do: position
    defp adjust(_, position), do: position

    defp numpad({9, 1}), do: 7
    defp numpad({1, 1}), do: "A"
    defp numpad({3, 1}), do: "C"
    defp numpad({3, 0}), do: "8"
  end
end
