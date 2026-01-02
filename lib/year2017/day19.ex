defmodule Aletopelta.Year2017.Day19 do
  @moduledoc """
  Day 19 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())
    @type output() :: none()

    @spec parse_input(input()) :: %{{integer(), integer()} => binary()}
    def parse_input(input) do
      input
      |> Enum.reject(fn line ->
        trimmed =
          line
          |> String.trim()
          |> String.length()

        trimmed === 0
      end)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reject(fn {cell, _} -> cell in [" "] end)
        |> Enum.map(fn {cell, x} -> {{x, y}, cell} end)
      end)
      |> Map.new()
    end

    @spec start(%{{integer(), integer()} => binary()}) :: {list(binary()), integer()}
    def start(map) do
      case find_start(map) do
        {position, "|"} -> follow({0, 1}, position, map, [], 0)
        {position, "-"} -> follow({1, 0}, position, map, [], 0)
      end
    end

    defp find_start(map),
      do:
        Enum.find_value(map, fn
          {{_, 0} = position, value} -> {position, value}
          _ -> nil
        end)

    defp follow(direction, position, map, path, steps),
      do:
        map
        |> Map.get(position)
        |> follow_path(direction, position, map, path, steps)

    defp follow_path("+", old_direction, {x, y}, map, path, steps),
      do:
        old_direction
        |> turn()
        |> Enum.map(fn {dx, dy} = direction ->
          follow(direction, {x + dx, y + dy}, map, path, steps + 1)
        end)
        |> Enum.max_by(fn {path, _} -> length(path) end)

    defp follow_path(pipe, {dx, dy} = direction, {x, y}, map, path, steps)
         when pipe in ["-", "|"], do: follow(direction, {x + dx, y + dy}, map, path, steps + 1)

    defp follow_path(nil, _, _, _, path, steps), do: {path, steps}

    defp follow_path(letter, {dx, dy} = direction, {x, y}, map, path, steps),
      do: follow(direction, {x + dx, y + dy}, map, [letter | path], steps + 1)

    defp turn({0, _}), do: [{1, 0}, {-1, 0}]
    defp turn({_, 0}), do: [{0, 1}, {0, -1}]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start()
      |> elem(0)
      |> Enum.reverse()
      |> Enum.join()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start()
      |> elem(1)
    end
  end
end
