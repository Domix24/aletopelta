defmodule Aletopelta.Year2022.Day23 do
  @moduledoc """
  Day 23 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """
    @spec parse_input(list(binary())) :: map()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, y ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn cell, x ->
          {{x, y}, cell}
        end)
      end)
      |> Enum.flat_map(& &1)
      |> Map.new()
    end

    @spec identify_elves(map()) :: MapSet.t()
    def identify_elves(map) do
      map
      |> Enum.filter(fn {_, cell} -> cell == "#" end)
      |> Enum.map(fn {cell, _} -> cell end)
      |> MapSet.new()
    end

    @spec remove_duplicate(list()) :: {MapSet.t(), boolean()}
    def remove_duplicate(positions) do
      positions
      |> identify_duplicate()
      |> process_duplicate()
    end

    defp process_duplicate({positions, duplicate}) do
      {new_positions, move?} =
        Enum.map_reduce(positions, false, fn
          {old, old}, move? ->
            {old, move?}

          {old, new}, move? ->
            if MapSet.member?(duplicate, old) do
              {old, move?}
            else
              {new, true}
            end
        end)

      {MapSet.new(new_positions), move?}
    end

    defp identify_duplicate(positions) do
      duplicate =
        positions
        |> Enum.group_by(fn {_, new} -> new end, fn {old, _} -> old end)
        |> Enum.filter(fn {_, list} -> Enum.count(list) > 1 end)
        |> Enum.flat_map(fn {_, list} -> list end)
        |> MapSet.new()

      {positions, duplicate}
    end

    @spec identify_position(MapSet.t(), integer()) :: list()
    def identify_position(elves, index) do
      Enum.map(elves, fn position ->
        result =
          index
          |> Range.new(index + 3)
          |> Enum.reduce_while(
            {0, {position, position}},
            &check_direction(&1, position, elves, &2)
          )

        case result do
          {n, _} when n in [0, 4] -> {position, position}
          {_, positions} -> positions
        end
      end)
    end

    defp check_direction(index, last_position, elves, {count, positions} = accumulator) do
      new_index = rem(index + 3, 4) + 1

      state =
        new_index
        |> get_directions(last_position)
        |> Enum.reduce_while(0, fn position, _ ->
          if MapSet.member?(elves, position) do
            {:halt, false}
          else
            {:cont, true}
          end
        end)

      cond do
        state and count == 0 ->
          new_position = get_direction(new_index, last_position)
          {:cont, {1, {last_position, new_position}}}

        state ->
          {:cont, {count + 1, positions}}

        count > 0 ->
          {:halt, {1, positions}}

        true ->
          {:cont, accumulator}
      end
    end

    defp get_directions(1, {x, y}) do
      [{x - 1, y - 1}, {x - 0, y - 1}, {x + 1, y - 1}]
    end

    defp get_directions(2, {x, y}) do
      [{x - 1, y + 1}, {x - 0, y + 1}, {x + 1, y + 1}]
    end

    defp get_directions(3, {x, y}) do
      [{x - 1, y - 1}, {x - 1, y - 0}, {x - 1, y + 1}]
    end

    defp get_directions(4, {x, y}) do
      [{x + 1, y - 1}, {x + 1, y - 0}, {x + 1, y + 1}]
    end

    defp get_direction(1, {x, y}), do: {x - 0, y - 1}
    defp get_direction(2, {x, y}), do: {x - 0, y + 1}
    defp get_direction(3, {x, y}), do: {x - 1, y - 0}
    defp get_direction(4, {x, y}), do: {x + 1, y - 0}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.identify_elves()
      |> process_rounds()
      |> find_rectangle()
    end

    defp find_rectangle(elves) do
      nb_elves = Enum.count(elves)

      {min_x, max_x} =
        elves
        |> Enum.group_by(fn {x, _} -> x end, fn {_, y} -> y end)
        |> Map.keys()
        |> Enum.min_max()

      {min_y, max_y} =
        elves
        |> Enum.group_by(fn {_, y} -> y end, fn {x, _} -> x end)
        |> Map.keys()
        |> Enum.min_max()

      Range.size(min_x..max_x) * Range.size(min_y..max_y) - nb_elves
    end

    defp process_rounds(elves) do
      Enum.reduce(1..10, elves, fn index, elves_acc ->
        {new_elves, _} =
          elves_acc
          |> Common.identify_position(index)
          |> Common.remove_duplicate()

        new_elves
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(list(binary())) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.identify_elves()
      |> process_rounds()
    end

    defp process_rounds(elves) do
      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while(elves, fn round, elves_acc ->
        {new_elves, move?} =
          elves_acc
          |> Common.identify_position(round)
          |> Common.remove_duplicate()

        if move? do
          {:cont, new_elves}
        else
          {:halt, round}
        end
      end)
    end
  end
end
