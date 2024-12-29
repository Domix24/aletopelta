defmodule Aletopelta.Day20241221 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      codes = parse_input(input)

      numberpad = %{
        {0, 0} => "7", {1, 0} => "8", {2, 0} => "9",
        {0, 1} => "4", {1, 1} => "5", {2, 1} => "6",
        {0, 2} => "1", {1, 2} => "2", {2, 2} => "3",
                       {1, 3} => "0", {2, 3} => "A",
      } |> Map.new(fn {position, key} -> {key, position} end)

      arrowpad = %{
                       {1, 0} => "^", {2, 0} => "A",
        {0, 1} => "<", {1, 1} => "v", {2, 1} => ">",
      } |> Map.new(fn {position, key} -> {key, position} end)

      codes
      |> Enum.map(&get_path(&1, numberpad))
      |> Enum.map(&get_path(&1, arrowpad))
      |> Enum.map(&get_path(&1, arrowpad))
      |> Enum.map(&calculate_complexity/1)
      |> Enum.sum
    end

    defp calculate_complexity({code, path}) do
      path_length = Enum.map(path, fn {_, n} -> n end) |> Enum.sum
      number = String.trim_leading(code, "0") |> String.trim_trailing("A") |> String.to_integer

      path_length * number
    end

    defp get_path({initial, path}, pad) do
      {initial, get_shortest([{"A", 1} | path], pad)}
    end

    defp get_path(code, pad), do: get_path({code, code |> String.graphemes |> Enum.map(&{&1, 1})}, pad)

    defp get_shortest([_], _), do: []

    defp get_shortest([{first_character, _}, {second_character, second_count} = second | others], pad) do
      {x1, y1} = Map.get(pad, first_character)
      {x2, y2} = Map.get(pad, second_character)

      direction = {first_character, get_vertical(y1, y2), get_horizontal(x1, x2)} |> make_valid
      direction = {{first_character, second_character}, direction} |> prioritize

      join_press(direction, second_count, get_shortest([second | others], pad))
    end

    defp join_press(first_list, increment, [{"A", n} | second_list]), do: first_list ++ [{"A", increment + n} | second_list]
    defp join_press(first_list, increment, second_list), do: first_list ++ [{"A", increment} | second_list]

    defp get_horizontal(x1, x2) when x1 > x2, do: {"<", x1 - x2}
    defp get_horizontal(x1, x2)             , do: {">", x2 - x1}

    defp get_vertical(y1, y2) when y1 > y2, do: {"^", y1 - y2}
    defp get_vertical(y1, y2)             , do: {"v", y2 - y1}

    defp make_valid({"<", {"^", n} = vertical, horizontal}) when n > 0, do: [horizontal, vertical]
    defp make_valid({"1", {"v", n} = vertical, horizontal}) when n > 0, do: [horizontal, vertical]
    defp make_valid({"4", {"v", n} = vertical, horizontal}) when n > 1, do: [horizontal, vertical]
    defp make_valid({"7", {"v", n} = vertical, horizontal}) when n > 2, do: [horizontal, vertical]
    defp make_valid({_, {_, 0}, {_, 0}}), do: []
    defp make_valid({_, vertical, {_, 0}}), do: [vertical]
    defp make_valid({_, {_, 0}, horizontal}), do: [horizontal]
    defp make_valid({_, vertical, horizontal}), do: [vertical, horizontal]

    defp prioritize({{f, "7"}, [vertical, horizontal]}) when f in ["2", "3", "5", "6"], do: [horizontal, vertical]
    defp prioritize({{f, "8"}, [vertical, horizontal]}) when f in ["A", "3", "6"], do: [horizontal, vertical]
    defp prioritize({{f, "4"}, [vertical, horizontal]}) when f in ["2", "3", "8", "9"], do: [horizontal, vertical]
    defp prioritize({{f, "5"}, [vertical, horizontal]}) when f in ["A", "3", "9"], do: [horizontal, vertical]
    defp prioritize({{f, "1"}, [vertical, horizontal]}) when f in ["5", "6", "8", "9"], do: [horizontal, vertical]
    defp prioritize({{f, "2"}, [vertical, horizontal]}) when f in ["A", "7", "9"], do: [horizontal, vertical]
    defp prioritize({{f, "^"}, [vertical, horizontal]}) when f in [">"], do: [horizontal, vertical]
    defp prioritize({_, direction}), do: direction

    defp parse_input(input) do
      input |> Enum.reject(& &1 == "")
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
