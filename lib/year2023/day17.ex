defmodule Aletopelta.Year2023.Day17 do
  @moduledoc """
  Day 17 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """
    def parse_input(input) do
      Enum.map(input, fn line ->
        String.graphemes(line)
        |> Enum.map(&String.to_integer/1)
      end)
    end

    def search_path(map, helpers) do
      target = length(map) - 1
      target = {target, target}
      start = {0, 0}

      distances = Map.new([{{start, nil, 0}, 0}])
      priority = :gb_sets.insert({0, 0, start, nil}, :gb_sets.new())

      search_path(map, target, distances, priority, helpers)
    end

    defp search_path(map, target, distances, priority, helpers) do
      {{heat, repetition, position, direction}, priority} = :gb_sets.take_smallest(priority)

      temp_helpers =
        case direction do
          nil -> {fn _ -> true end, fn _ -> true end}
          _ -> helpers
        end

      case position do
        ^target ->
          heat

        position ->
          {distances, priority} =
            get_available(direction)
            |> Enum.map(&add_repetition(&1, direction, repetition, position, temp_helpers))
            |> Enum.reject(&(!valid?(&1, target)))
            |> Enum.reduce({distances, priority}, fn {{x, y}, _, _} = key, acc ->
              Enum.at(map, y)
              |> Enum.at(x)
              |> Kernel.+(heat)
              |> build_priority(acc, key)
            end)

          search_path(map, target, distances, priority, helpers)
      end
    end

    defp build_priority(
           new_heat,
           {distances, priority} = acc,
           {position, direction, repetition} = key
         ) do
      if Map.get(distances, key) <= new_heat do
        acc
      else
        distances = Map.put(distances, key, new_heat)
        priority = :gb_sets.insert({new_heat, repetition, position, direction}, priority)

        {distances, priority}
      end
    end

    defp add_repetition(direction, direction, repetition, {x, y}, {_, max_path}) do
      if max_path.(repetition) do
        {dx, dy} = get_delta(direction)
        position = {x + dx, y + dy}
        {position, direction, repetition + 1}
      else
        nil
      end
    end

    defp add_repetition(new_direction, _, repetition, {x, y}, {min_path, _}) do
      if min_path.(repetition) do
        {dx, dy} = get_delta(new_direction)
        position = {x + dx, y + dy}
        {position, new_direction, 1}
      else
        nil
      end
    end

    defp get_available(nil) do
      [:north, :east, :south, :west]
    end

    defp get_available(:north) do
      [:north, :east, :west]
    end

    defp get_available(:east) do
      [:east, :north, :south]
    end

    defp get_available(:south) do
      [:south, :east, :west]
    end

    defp get_available(:west) do
      [:west, :north, :south]
    end

    defp get_delta(:north) do
      {-1, 0}
    end

    defp get_delta(:east) do
      {0, 1}
    end

    defp get_delta(:south) do
      {1, 0}
    end

    defp get_delta(:west) do
      {0, -1}
    end

    defp valid?(nil, _) do
      false
    end

    defp valid?({{-1, _}, _, _}, _) do
      false
    end

    defp valid?({{_, -1}, _, _}, _) do
      false
    end

    defp valid?({{x, _}, _, _}, {m, _}) when x == m + 1, do: false
    defp valid?({{_, y}, _, _}, {m, _}) when y == m + 1, do: false

    defp valid?(_, _) do
      true
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.search_path({&min_path/1, &max_path/1})
    end

    defp min_path(_) do
      true
    end

    defp max_path(c) do
      c < 3
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.search_path({&min_path/1, &max_path/1})
    end

    defp min_path(c) do
      c > 3
    end

    defp max_path(c) do
      c < 10
    end
  end
end
