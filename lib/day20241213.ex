defmodule Aletopelta.Day20241213 do
  defmodule Common do
    @regex_button ~r/(a|b):.+([-+]\d+).+([-+]\d+)/i
    @regex_prize ~r/pri.*=(\d+).+=(\d+)/i

    def linearize([]), do: []

    def linearize([[_, a_x, a_y], [_, b_x, b_y], [r_x, r_y]]) do
      {x, y} = solve_equation({a_x, a_y}, {b_x, b_y}, {r_x, r_y})
      if valid_solution?({a_x, a_y}, {b_x, b_y}, {x, y}, {r_x, r_y}), do: {x, y}, else: {0, 0}
    end

    def linearize([first | rest]), do: [linearize(first) |linearize(rest)]

    defp solve_equation({a_x, a_y}, {b_x, b_y}, {r_x, r_y}) do
      x = div(r_y * b_x - r_x * b_y, a_y * b_x - a_x * b_y)
      y = div(r_x - a_x * x, b_x)
      {x, y}
    end

    defp valid_solution?({a_x, a_y}, {b_x, b_y}, {x, y}, {r_x, r_y}) do
      a_x * x + b_x * y == r_x and a_y * x + b_y * y == r_y
    end

    def parse_input(input), do: parse_input(input, [])
    def parse_input([], _), do: []
    def parse_input([_ | rest], state) when length(state) > 2 do
      [state] ++ parse_input(rest, [])
    end
    def parse_input([first | rest], state) do
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

    def calculate_sum(values) do
      values
      |> Enum.reduce(0, fn {x, y}, acc -> x * 3 + y + acc end)
    end
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> Common.linearize
      |> Common.calculate_sum
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> increment_results
      |> Common.linearize
      |> Common.calculate_sum
    end

    defp increment_results(input, increment \\ 10000000000000) do
      input
      |> Enum.map(fn [a, b, [r_x, r_y]] -> [a, b, [r_x + increment, r_y + increment]] end)
    end
  end
end
