defmodule Aletopelta.Year2021.Day02 do
  @moduledoc """
  Day 2 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """
    @spec parse_input([binary()]) :: [{binary(), number()}]
    def parse_input(input) do
      Enum.map(input, fn line ->
        [direction, amount] = String.split(line)

        {direction, String.to_integer(amount)}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute([binary()], []) :: number()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> move({0, 0})
    end

    defp move([], {x, y}), do: x * y
    defp move([{"forward", dx} | others], {x, y}), do: move(others, {x + dx, y})
    defp move([{"up", dy} | others], {x, y}), do: move(others, {x, y - dy})
    defp move([{"down", dy} | others], {x, y}), do: move(others, {x, y + dy})
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute([binary()], []) :: number()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> move({0, 0, 0})
    end

    defp move([], {x, y, _}), do: x * y
    defp move([{"forward", dx} | others], {x, y, z}), do: move(others, {x + dx, y + z * dx, z})
    defp move([{"up", dz} | others], {x, y, z}), do: move(others, {x, y, z - dz})
    defp move([{"down", dz} | others], {x, y, z}), do: move(others, {x, y, z + dz})
  end
end
