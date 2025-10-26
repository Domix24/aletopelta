defmodule Aletopelta.Year2018.Day20 do
  @moduledoc """
  Day 20 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type direction() :: atom() | {atom(), list(atom())}
    @type output() :: list(direction())
    @type sides() :: %{{integer(), integer()} => list({integer(), integer()})}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> parse_line()
    end

    defp parse_line("^" <> rest),
      do:
        rest
        |> parse_expression()
        |> elem(0)

    defp parse_expression("" = input), do: {[], input}
    defp parse_expression("$"), do: {[], ""}
    defp parse_expression("|" <> _ = input), do: {[], input}
    defp parse_expression(")" <> _ = input), do: {[], input}

    defp parse_expression("E" <> rest) do
      {next, new_rest} = parse_expression(rest)
      {[:east | next], new_rest}
    end

    defp parse_expression("W" <> rest) do
      {next, new_rest} = parse_expression(rest)
      {[:west | next], new_rest}
    end

    defp parse_expression("S" <> rest) do
      {next, new_rest} = parse_expression(rest)
      {[:south | next], new_rest}
    end

    defp parse_expression("N" <> rest) do
      {next, new_rest} = parse_expression(rest)
      {[:north | next], new_rest}
    end

    defp parse_expression("(" <> rest) do
      {choices, new_rest, type} = parse_branches(rest)
      {next, another_rest} = parse_expression(new_rest)
      {[{type, choices} | next], another_rest}
    end

    defp parse_branches(input) do
      case parse_expression(input) do
        {sequence, "|)" <> rest} ->
          {[sequence], rest, :withempty}

        {sequence, "|" <> rest} ->
          {other, new_rest, type} = parse_branches(rest)
          {[sequence | other], new_rest, type}

        {sequence, ")" <> rest} ->
          {[sequence], rest, :withoutempty}
      end
    end

    @spec build_sides(output()) :: sides()
    def build_sides(directions),
      do:
        directions
        |> build_sides(Map.new(), MapSet.new([{0, 0}]))
        |> elem(0)

    defp build_sides(old_directions, old_sides, old_positions) do
      Enum.reduce(old_directions, {old_sides, old_positions}, &build_side/2)
    end

    defp build_side({:withoutempty, directions}, {sides_acc, positions_acc}) do
      Enum.reduce(directions, {sides_acc, MapSet.new()}, fn direction,
                                                            {acc_sides, acc_positions} ->
        {new_sides, alternate_positions} = build_sides(direction, acc_sides, positions_acc)
        new_positions = MapSet.union(alternate_positions, acc_positions)
        {new_sides, new_positions}
      end)
    end

    defp build_side({:withempty, directions}, {sides_acc, positions_acc}) do
      Enum.reduce(directions, {sides_acc, positions_acc}, fn direction,
                                                             {acc_sides, acc_positions} ->
        {new_sides, alternate_positions} = build_sides(direction, acc_sides, positions_acc)
        new_positions = MapSet.union(alternate_positions, acc_positions)
        {new_sides, new_positions}
      end)
    end

    defp build_side(direction, {sides_acc, positions_acc}) do
      Enum.reduce(positions_acc, {sides_acc, MapSet.new()}, fn position,
                                                               {acc_sides, acc_positions} ->
        new_position = move(direction, position)

        new_sides =
          acc_sides
          |> Map.update(position, MapSet.new([new_position]), &MapSet.put(&1, new_position))
          |> Map.update(new_position, MapSet.new([position]), &MapSet.put(&1, position))

        new_positions = MapSet.put(acc_positions, new_position)

        {new_sides, new_positions}
      end)
    end

    defp move(:east, {x, y}), do: {x + 1, y}
    defp move(:west, {x, y}), do: {x - 1, y}
    defp move(:north, {x, y}), do: {x, y + 1}
    defp move(:south, {x, y}), do: {x, y - 1}

    @spec follow_sides(sides()) :: {integer(), integer()}
    def follow_sides(sides), do: follow_sides(sides, MapSet.new([{0, 0}]), 0, 0)

    defp follow_sides(sides, rooms, distance, room_count) do
      {new_sides, new_rooms} =
        Enum.reduce(rooms, {sides, MapSet.new()}, fn room, {acc_sides, acc_rooms} ->
          new_rooms =
            acc_sides
            |> Map.fetch!(room)
            |> Enum.filter(&Map.has_key?(acc_sides, &1))
            |> MapSet.new()
            |> MapSet.union(acc_rooms)

          new_sides = Map.delete(acc_sides, room)

          {new_sides, new_rooms}
        end)

      new_count =
        if distance > 998 do
          Enum.count(new_rooms) + room_count
        else
          room_count
        end

      if Enum.empty?(new_sides) do
        {distance, new_count}
      else
        follow_sides(new_sides, new_rooms, distance + 1, new_count)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_sides()
      |> Common.follow_sides()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_sides()
      |> Common.follow_sides()
      |> elem(1)
    end
  end
end
