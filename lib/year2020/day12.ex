defmodule Aletopelta.Year2020.Day12 do
  @moduledoc """
  Day 12 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type cardinal() :: :east | :west | :south | :north
    @type direction() :: cardinal() | :left | :right

    @spec parse_input(input()) :: keyword(integer())
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r/([A-Z]{1})(\d+)/
        |> Regex.run(line, capture: :all_but_first)
        |> convert_input()
      end)
    end

    defp convert_input([first, second]), do: {to_atom(first), String.to_integer(second)}

    defp to_atom("N"), do: :north
    defp to_atom("S"), do: :south
    defp to_atom("L"), do: :left
    defp to_atom("R"), do: :right
    defp to_atom("F"), do: :front
    defp to_atom("W"), do: :west
    defp to_atom("E"), do: :east

    @spec manhattan({integer(), integer()}) :: integer()
    def manhattan({x, y}), do: abs(x) + abs(y)

    @spec clockwise(cardinal()) :: cardinal()
    def clockwise(:east), do: :south
    def clockwise(:south), do: :west
    def clockwise(:west), do: :north
    def clockwise(:north), do: :east

    @spec counterclockwise(cardinal()) :: cardinal()
    def counterclockwise(facing),
      do:
        facing
        |> clockwise()
        |> opposite()

    @spec opposite(direction()) :: direction()
    def opposite(:east), do: :west
    def opposite(:south), do: :north
    def opposite(:west), do: :east
    def opposite(:north), do: :south
    def opposite(:left), do: :right
    def opposite(:right), do: :left
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
      |> Common.manhattan()
    end

    defp prepare_loop(instructions) do
      do_loop(instructions, %{x: 0, y: 0, facing: :east})
    end

    defp do_loop([], %{x: x, y: y}), do: {x, y}

    defp do_loop([instruction | instructions], position) do
      instruction
      |> move(position)
      |> continue(instructions)
    end

    defp move({:east, amount}, position), do: %{position | x: position.x + amount}
    defp move({:west, amount}, position), do: %{position | x: position.x - amount}
    defp move({:north, amount}, position), do: %{position | y: position.y + amount}
    defp move({:south, amount}, position), do: %{position | y: position.y - amount}

    defp move({:front, amount}, position), do: move({position.facing, amount}, position)

    defp move({:left, 90}, position),
      do: %{position | facing: Common.counterclockwise(position.facing)}

    defp move({:right, 90}, position), do: %{position | facing: Common.clockwise(position.facing)}
    defp move({_, 180}, position), do: %{position | facing: Common.opposite(position.facing)}
    defp move({direction, 270}, position), do: move({Common.opposite(direction), 90}, position)

    defp continue(position, instructions), do: do_loop(instructions, position)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
      |> Common.manhattan()
    end

    defp prepare_loop(instructions) do
      do_loop(instructions, %{x: 0, y: 0, facing: :east}, %{x: 10, y: 1})
    end

    defp do_loop([], %{x: x, y: y}, _), do: {x, y}

    defp do_loop([instruction | instructions], position, waypoint) do
      instruction
      |> move(position, waypoint)
      |> continue(instructions)
    end

    defp move({:east, amount}, position, waypoint),
      do: {position, %{waypoint | x: waypoint.x + amount}}

    defp move({:west, amount}, position, waypoint),
      do: {position, %{waypoint | x: waypoint.x - amount}}

    defp move({:north, amount}, position, waypoint),
      do: {position, %{waypoint | y: waypoint.y + amount}}

    defp move({:south, amount}, position, waypoint),
      do: {position, %{waypoint | y: waypoint.y - amount}}

    defp move({:front, amount}, position, waypoint),
      do:
        {%{position | x: position.x + waypoint.x * amount, y: position.y + waypoint.y * amount},
         waypoint}

    defp move({:left, 90}, position, waypoint),
      do: {position, %{waypoint | x: -waypoint.y, y: waypoint.x}}

    defp move({:right, 90}, position, waypoint),
      do: {position, %{waypoint | x: waypoint.y, y: -waypoint.x}}

    defp move({_, 180}, position, waypoint),
      do: {position, %{waypoint | x: -waypoint.x, y: -waypoint.y}}

    defp move({direction, 270}, position, waypoint),
      do: move({Common.opposite(direction), 90}, position, waypoint)

    defp continue({position, waypoint}, instructions),
      do: do_loop(instructions, position, waypoint)
  end
end
