defmodule Aletopelta.Year2019.Day06 do
  @moduledoc """
  Day 6 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: {%{binary() => 0}, %{binary() => binary()}}
    def parse_input(input) do
      Enum.reduce(input, {Map.new(), Map.new()}, fn line, {acc_objects, acc_orbits} ->
        [center, orbit] = String.split(line, ")")

        new_objects =
          acc_objects
          |> Map.put(center, 0)
          |> Map.put(orbit, 0)

        new_orbits = Map.put(acc_orbits, orbit, center)

        {new_objects, new_orbits}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop({object_map, orbits}),
      do:
        object_map
        |> Enum.to_list()
        |> do_loop({0, orbits})

    defp do_loop([], {stop, _}), do: stop

    defp do_loop(objects, {_, orbits} = info),
      do:
        objects
        |> Enum.map(fn {object, count} ->
          case Map.fetch(orbits, object) do
            {:ok, orbit} -> {:continue, {orbit, count + 1}}
            :error -> {:stop, count}
          end
        end)
        |> Enum.split_with(&(elem(&1, 0) == :continue))
        |> setup_loop(info)

    defp setup_loop({continue, stop_list}, {stop, orbits}) do
      stop_count = Enum.sum_by(stop_list, &elem(&1, 1))

      continue
      |> Enum.map(&elem(&1, 1))
      |> do_loop({stop + stop_count, orbits})
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_orbits()
      |> Enum.frequencies()
      |> Enum.count(&(elem(&1, 1) == 1))
    end

    defp find_orbits({_, orbits}) do
      san = find_orbits(orbits, "SAN")
      you = find_orbits(orbits, "YOU")

      san ++ you
    end

    defp find_orbits(orbits, object) do
      case Map.fetch(orbits, object) do
        {:ok, new_object} -> [new_object | find_orbits(orbits, new_object)]
        :error -> []
      end
    end
  end
end
