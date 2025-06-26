defmodule Aletopelta.Year2021.Day25 do
  @moduledoc """
  Day 25 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: [binary()]

    @spec parse_input(input()) :: %{{integer(), integer()} => :east | :south | :empty}
    def parse_input(input) do
      input
      |> Enum.reduce({0, Map.new()}, fn line, {y, acc} ->
        parse_line(line, {0, y}, acc)
      end)
      |> elem(1)
    end

    defp parse_line(<<".", rest::binary>>, {x, y}, acc) do
      new_acc = Map.put(acc, {x, y}, :empty)
      parse_line(rest, {x + 1, y}, new_acc)
    end

    defp parse_line(<<"v", rest::binary>>, {x, y}, acc) do
      new_acc = Map.put(acc, {x, y}, :south)
      parse_line(rest, {x + 1, y}, new_acc)
    end

    defp parse_line(<<">", rest::binary>>, {x, y}, acc) do
      new_acc = Map.put(acc, {x, y}, :east)
      parse_line(rest, {x + 1, y}, new_acc)
    end

    defp parse_line("", {_, y}, acc) do
      {y + 1, acc}
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
      |> do_steps(1)
    end

    defp do_steps(grid, count) do
      {temp_grid, moved_east?} =
        grid
        |> Enum.to_list()
        |> move(grid, [], :east)

      {new_grid, moved_south?} =
        temp_grid
        |> Enum.to_list()
        |> move(temp_grid, [], :south)

      if moved_east? or moved_south? do
        do_steps(new_grid, count + 1)
      else
        count
      end
    end

    defp move([], grid, [], _), do: {grid, false}

    defp move([], grid, [{from, to} | moves], direction) do
      temp_grid =
        grid
        |> Map.put(from, :empty)
        |> Map.put(to, direction)

      {new_grid, _} = move([], temp_grid, moves, direction)

      {new_grid, true}
    end

    defp move([{position, direction} | rest], grid, moves, direction) do
      case next_position(grid, get_next(position, direction), direction) do
        {next, :empty} -> move(rest, grid, [{position, next} | moves], direction)
        _ -> move(rest, grid, moves, direction)
      end
    end

    defp move([_ | rest], grid, moves, direction), do: move(rest, grid, moves, direction)

    defp get_next({x, y}, :east), do: {x + 1, y}
    defp get_next({x, y}, :south), do: {x, y + 1}

    defp next_position(grid, {x, y} = position, direction) do
      case {Map.fetch(grid, position), direction} do
        {:error, :south} -> next_position(grid, {x, 0}, direction)
        {:error, :east} -> next_position(grid, {0, y}, direction)
        {{:ok, state}, _} -> {position, state}
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: 0
    def execute(input, []) do
      Common.parse_input(input)
      0
    end
  end
end
