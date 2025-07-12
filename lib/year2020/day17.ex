defmodule Aletopelta.Year2020.Day17 do
  @moduledoc """
  Day 17 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())
    @type point() :: {integer(), integer(), integer(), integer()}
    @type cubes() :: %{point() => :active | :inactive}

    @spec parse_input(input()) :: cubes()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn
          ".", x -> {{x, y, 0, 0}, :inactive}
          "#", x -> {{x, y, 0, 0}, :active}
        end)
      end)
      |> Map.new()
    end

    @spec do_cycle(cubes(), integer(), (-> list(point()))) :: cubes()
    def do_cycle(cubes, 0, _), do: cubes

    def do_cycle(cubes, max, neighbors) do
      cubes
      |> Enum.flat_map(fn {position, _} -> neighbors(position, neighbors) end)
      |> Enum.uniq()
      |> Map.new(fn position ->
        nbact =
          position
          |> neighbors(neighbors)
          |> Enum.reduce_while(0, &count_active(&1, &2, cubes))

        nstate = Map.get(cubes, position, :inactive)

        nactivity =
          cond do
            nstate == :active and nbact not in 2..3 -> :inactive
            nstate == :inactive and nbact == 3 -> :active
            true -> nstate
          end

        {position, nactivity}
      end)
      |> do_cycle(max - 1, neighbors)
    end

    defp count_active(position, acc, cubes),
      do:
        cubes
        |> Map.get(position, :inactive)
        |> sum_active(acc)

    defp sum_active(:active, 3), do: {:halt, 4}
    defp sum_active(:active, n), do: {:cont, n + 1}
    defp sum_active(_, n), do: {:cont, n}

    defp neighbors({x, y, z, w}, neighbors_function),
      do:
        Enum.map(neighbors_function.(), fn {dx, dy, dz, dw} ->
          {x + dx, y + dy, z + dz, w + dw}
        end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_cycle(6, &neighbors/0)
      |> Enum.count(&(elem(&1, 1) == :active))
    end

    defp neighbors do
      for dx <- -1..1,
          dy <- -1..1,
          dz <- -1..1,
          {dx, dy, dz} != {0, 0, 0} do
        {dx, dy, dz, 0}
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_cycle(6, &neighbors/0)
      |> Enum.count(&(elem(&1, 1) == :active))
    end

    defp neighbors do
      for dx <- -1..1,
          dy <- -1..1,
          dz <- -1..1,
          dw <- -1..1,
          {dx, dy, dz, dw} != {0, 0, 0, 0} do
        {dx, dy, dz, dw}
      end
    end
  end
end
