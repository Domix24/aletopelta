defmodule Aletopelta.Year2023.Day25 do
  @moduledoc """
  Day 25 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """
    def parse_input(input) do
      Enum.reduce input, %{}, fn line, graph ->
        [[component] | components] = Regex.scan(~r/[a-zA-Z]+/, line)
        Enum.reduce components, graph, fn [compo], graph ->
          Map.update(graph, component, MapSet.new([compo]), &MapSet.put(&1, compo))
          |> Map.update(compo, MapSet.new([component]), &MapSet.put(&1, component))
        end
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    def execute(input) do
      Common.parse_input(input)
      |> then(fn graph ->
        keys = Map.keys(graph)
        |> MapSet.new

        do_thing(graph, keys)
        |> Stream.map(fn keys ->
          size = Map.keys(graph)
          |> MapSet.new
          |> MapSet.difference(keys)
          |> MapSet.size

          MapSet.size(keys) * size
        end)
        |> Enum.at(0)
      end)
    end

    defp do_thing graph, keys do
      loopy = fn key ->
        MapSet.difference(Map.fetch!(graph, key), keys)
        |> MapSet.size
      end

      Enum.sum_by(keys, loopy)
      |> case do
        3 ->
          [keys]

        _ ->
          Enum.group_by(keys, loopy)
          |> Enum.max_by(&elem(&1, 0))
          |> elem(1)
          |> case do
            [key] ->
              do_thing graph, MapSet.delete(keys, key)

            [_ | _] = possible_keys ->
              process_keys possible_keys, keys, graph
          end
      end
    end

    defp process_keys possible_keys, keys, graph do
      Enum.reduce_while possible_keys, :error, fn key, _ ->
        try do
          do_thing(graph, MapSet.delete(keys, key))
          |> case do
            :error -> {:cont, :error}
            good -> {:halt, good}
          end
        rescue
          _ ->
            {:cont, :error}
        end
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    def execute(input) do
      Common.parse_input(input)
      0
    end
  end
end
