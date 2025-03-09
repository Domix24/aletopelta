defmodule Aletopelta.Year2024.Day21 do
  @moduledoc """
  Day 21 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """
    def parse_input(input) do
      input |> Enum.reject(&(&1 == ""))
    end

    defp get_number_pad do
      %{
        {0, 0} => "7",
        {1, 0} => "8",
        {2, 0} => "9",
        {0, 1} => "4",
        {1, 1} => "5",
        {2, 1} => "6",
        {0, 2} => "1",
        {1, 2} => "2",
        {2, 2} => "3",
        {1, 3} => "0",
        {2, 3} => "A"
      }
      |> Map.new(fn {position, key} -> {key, position} end)
    end

    defp get_arrow_pad do
      %{
        {1, 0} => "^",
        {2, 0} => "A",
        {0, 1} => "<",
        {1, 1} => "v",
        {2, 1} => ">"
      }
      |> Map.new(fn {position, key} -> {key, position} end)
    end

    def handle_complexity(code, count) do
      code
      |> get_path(get_number_pad())
      |> group_sequence
      |> process_arrow_pad(count, code)
      |> calculate_complexity
    end

    defp calculate_complexity({code, path}) do
      path_length = Enum.map(path, fn {_, n} -> n end) |> Enum.sum()
      number = String.trim_leading(code, "0") |> String.trim_trailing("A") |> String.to_integer()

      path_length * number
    end

    defp get_path({initial, path}, pad) do
      {initial, get_shortest([{"A", 1} | path], pad)}
    end

    defp get_path(code, pad),
      do: get_path({code, code |> String.graphemes() |> Enum.map(&{&1, 1})}, pad)

    defp get_shortest([_], _), do: []

    defp get_shortest(
           [{first_character, _}, {second_character, second_count} = second | others],
           pad
         ) do
      {x1, y1} = Map.get(pad, first_character)
      {x2, y2} = Map.get(pad, second_character)

      [get_horizontal(x1, x2), get_vertical(y1, y2)]
      |> prioritize
      |> make_valid({first_character, second_character})
      |> Enum.reject(fn {_, count} -> count == 0 end)
      |> join_press(second_count, get_shortest([second | others], pad))
    end

    defp group_sequence({_, signs}) do
      group_sequence(signs, "", %{})
    end

    defp group_sequence([], "", map), do: map

    defp group_sequence([{"A", 0} | others], sequence, map),
      do: group_sequence(others, sequence, map)

    defp group_sequence([{"A", count} | others], sequence, map) do
      sequence = sequence <> "A"
      map = Map.update(map, sequence, 1, &(&1 + 1))
      group_sequence([{"A", count - 1} | others], "", map)
    end

    defp group_sequence([{sign, count} | others], sequence, map) do
      sign_sequence = for _ <- 1..count, do: [sign]
      sequence = sequence <> (sign_sequence |> Enum.join())
      group_sequence(others, sequence, map)
    end

    defp process_arrow_pad(sequence_group, 0, code) do
      path =
        Enum.flat_map(sequence_group, fn {longsign, frequence} ->
          String.graphemes(longsign)
          |> Enum.map(&{&1, frequence})
        end)

      {code, path}
    end

    defp process_arrow_pad(sequence_group, loop_index, code) do
      Enum.reduce(sequence_group, %{}, fn {key, tvalue}, acc ->
        get_path(key, get_arrow_pad())
        |> group_sequence
        |> Enum.reduce(acc, fn {key, value}, acc ->
          Map.update(acc, key, value * tvalue, &(&1 + value * tvalue))
        end)
      end)
      |> process_arrow_pad(loop_index - 1, code)
    end

    defp join_press(first_list, increment, [{"A", n} | second_list]),
      do: first_list ++ [{"A", increment + n} | second_list]

    defp join_press(first_list, increment, second_list),
      do: first_list ++ [{"A", increment} | second_list]

    defp get_horizontal(x1, x2) when x1 > x2, do: {"<", x1 - x2}
    defp get_horizontal(x1, x2), do: {">", x2 - x1}

    defp get_vertical(y1, y2) when y1 > y2, do: {"^", y1 - y2}
    defp get_vertical(y1, y2), do: {"v", y2 - y1}

    defp prioritize([{">", _} = horizontal, vertical]), do: [vertical, horizontal]
    defp prioritize([horizontal, vertical]), do: [horizontal, vertical]

    defp make_valid([direction1, direction2], {"7", "A"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"4", "A"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"1", "A"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"7", "0"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"4", "0"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"1", "0"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"0", "7"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"0", "4"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"0", "1"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"A", "7"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"A", "4"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"A", "1"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"^", "<"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"A", "<"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"<", "^"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {"<", "A"}), do: [direction2, direction1]
    defp make_valid([direction1, direction2], {_fr, _t}), do: [direction1, direction2]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&Common.handle_complexity(&1, 2))
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&Common.handle_complexity(&1, 25))
      |> Enum.sum()
    end
  end
end
