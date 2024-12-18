defmodule Aletopelta.Day20241213 do
  defmodule Common do
  end

  defmodule Part1 do
    @regex_button ~r/(a|b):.+([-+]\d+).+([-+]\d+)/i
    @regex_prize ~r/pri.*=(\d+).+=(\d+)/i

    def execute(input \\ nil) do
      input
      |> parse_input
      |> linearize
      |> calculate_sum
    end

    defp linearize([]), do: []

    defp linearize([[_, a_x, a_y], [_, b_x, b_y], [r_x, r_y]]) do
      {x, y} = solve_equation({a_x, a_y}, {b_x, b_y}, {r_x, r_y})
      if valid_solution?({a_x, a_y}, {b_x, b_y}, {x, y}, {r_x, r_y}), do: {x, y}, else: {0, 0}
    end

    defp linearize([first | rest]), do: [linearize(first) |linearize(rest)]

    defp solve_equation({a_x, a_y}, {b_x, b_y}, {r_x, r_y}) do
      x = div(r_y * b_x - r_x * b_y, a_y * b_x - a_x * b_y)
      y = div(r_x - a_x * x, b_x)
      {x, y}
    end

    defp valid_solution?({a_x, a_y}, {b_x, b_y}, {x, y}, {r_x, r_y}) do
      a_x * x + b_x * y == r_x and a_y * x + b_y * y == r_y
    end

    defp parse_input(input), do: parse_input(input, [])
    defp parse_input([], _), do: []
    defp parse_input([_ | rest], state) when length(state) > 2 do
      [state] ++ parse_input(rest, [])
    end
    defp parse_input([first | rest], state) do
      state = first
      |> parse_line(state)

      rest
      |> parse_input(state)
    end

    defp parse_line(line, state) do
      cond do
        String.match?(line, @regex_button) -> parse_button(line, state)
        String.match?(line, @regex_prize) -> parse_prize(line, state)
        true -> state
      end
    end

    defp parse_button(line, state) do
      case Regex.run(@regex_button, line) do
        [_, "A", num1, num2] -> [["A", String.to_integer(num1), String.to_integer(num2)]]
        [_, "B", num1, num2] -> state ++ [["B", String.to_integer(num1), String.to_integer(num2)]]
        _ -> state
      end
    end

    defp parse_prize(line, state) do
      case Regex.run(@regex_prize, line) do
        [_, num1, num2] -> state ++ [[String.to_integer(num1), String.to_integer(num2)]]
        _ -> state
      end
    end

    defp calculate_sum(values) do
      values
      |> Enum.reduce(0, fn {x, y}, acc -> x * 3 + y + acc end)
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
