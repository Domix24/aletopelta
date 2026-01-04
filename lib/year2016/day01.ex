defmodule Aletopelta.Year2016.Day01 do
  @moduledoc """
  Day 1 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type position() :: {integer(), integer()}
    @type direction() :: :R | :L

    @spec parse_input(input()) :: list({direction(), integer()})
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(", ")
      |> Enum.map(fn line ->
        [direction, number] =
          ~r"([LR])(\d+)"
          |> Regex.run(line)
          |> Enum.drop(1)
          |> Enum.with_index(fn
            direction, 0 -> Enum.at(~w"#{direction}"a, 0)
            number, 1 -> String.to_integer(number)
          end)

        {direction, number}
      end)
    end

    @spec rotate(position(), direction()) :: position()
    def rotate({x, y}, :R), do: {-y, x}
    def rotate({x, y}, :L), do: {y, -x}

    @spec move(position(), position(), integer()) :: position()
    def move({dx, dy}, {x, y}, factor), do: {x + dx * factor, y + dy * factor}

    @spec sum(position()) :: integer()
    def sum({x, y}), do: abs(x) + abs(y)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce({{0, 0}, {0, -1}}, &process/2)
      |> elem(0)
      |> Common.sum()
    end

    defp process({direction, count}, {position, facing}) do
      new_facing = Common.rotate(facing, direction)
      new_position = Common.move(new_facing, position, count)

      {new_position, new_facing}
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce_while({{0, 0}, {0, -1}, Map.new()}, &process/2)
      |> Common.sum()
    end

    defp process({direction, count}, {position, facing, seen}) do
      new_facing = Common.rotate(facing, direction)
      new_position = Common.move(new_facing, position, count)

      new_facing
      |> loop_find(position, new_position, seen)
      |> process_return(new_position, new_facing)
    end

    defp loop_find({0, _}, {x, oy}, {x, ny}, seen),
      do:
        oy
        |> build_range(ny)
        |> Enum.drop(1)
        |> Enum.reduce_while(seen, fn
          y, _ when is_map_key(seen, {x, y}) -> {:halt, {:found, {x, y}}}
          y, acc -> {:cont, Map.put(acc, {x, y}, 1)}
        end)

    defp loop_find({_, 0}, {ox, y}, {nx, y}, seen),
      do:
        ox
        |> build_range(nx)
        |> Enum.drop(1)
        |> Enum.reduce_while(seen, fn
          x, _ when is_map_key(seen, {x, y}) -> {:halt, {:found, {x, y}}}
          x, acc -> {:cont, Map.put(acc, {x, y}, 1)}
        end)

    defp build_range(first, last) when first > last, do: first..last//-1
    defp build_range(first, last), do: first..last//1

    defp process_return({:found, position}, _, _), do: {:halt, position}
    defp process_return(seen, position, facing), do: {:cont, {position, facing, seen}}
  end
end
