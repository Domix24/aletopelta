defmodule Aletopelta.Year2025.Day10 do
  @moduledoc """
  Day 10 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list({list(integer()), list(list(integer())), list(integer())})
    def parse_input(input) do
      Enum.map(input, fn line ->
        machine =
          ~r"\[([\#\.]+)\]"
          |> Regex.scan(line)
          |> Enum.flat_map(fn [_, symbol] ->
            String.graphemes(symbol)
          end)

        numbers =
          ~r"\(([\d,]+)\)"
          |> Regex.scan(line)
          |> Enum.map(fn [_, numbers] ->
            numbers
            |> String.split(",")
            |> Enum.map(&String.to_integer(&1))
          end)

        joltages =
          ~r"\{([\d,]+)\}"
          |> Regex.scan(line)
          |> Enum.flat_map(fn [_, numbers] ->
            numbers
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
          end)

        {machine, numbers, joltages}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&trick_machine/1)
    end

    defp trick_machine({goal, buttons, _} = _) do
      start = {clear(goal), 0}

      trick_machine({[start], []}, goal, buttons, Map.new())
    end

    defp trick_machine({[], [_ | _] = next_states}, goal, buttons, seen) do
      states = Enum.reverse(next_states)
      trick_machine({states, []}, goal, buttons, seen)
    end

    defp trick_machine({[{state, _} | states], next_states} = complete, goal, buttons, seen) do
      if is_map_key(seen, state) do
        trick_machine({states, next_states}, goal, buttons, seen)
      else
        trick_machine2(complete, goal, buttons, seen)
      end
    end

    defp trick_machine2({[{goal, press} | _], _}, goal, _, _), do: press

    defp trick_machine2({[{state, press} | states], next_states}, goal, buttons, seen) do
      new_seen = Map.put(seen, state, 1)

      new_states = Enum.reduce(buttons, next_states, &reduce(&1, &2, state, press))

      trick_machine({states, new_states}, goal, buttons, new_seen)
    end

    defp reduce(group, acc_states, state, press) do
      new_state =
        Enum.reduce(group, state, fn button, acc_state ->
          Enum.with_index(acc_state, fn
            symbol, ^button -> toggle(symbol)
            symbol, _ -> symbol
          end)
        end)

      [{new_state, press + 1} | acc_states]
    end

    defp clear([]), do: []
    defp clear([_ | rest]), do: ["." | clear(rest)]

    defp toggle("#"), do: "."
    defp toggle("."), do: "#"
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&reduce/1)
    end

    @max_sum 1000
    @threshold 6

    defp new(num, den \\ 1) when den != 0 do
      g = gcd(abs(num), abs(den))
      sign = if num * den < 0, do: -1, else: 1
      %{num: sign * div(abs(num), g), den: div(abs(den), g)}
    end

    defp add(%{num: n1, den: d1}, %{num: n2, den: d2}), do: new(n1 * d2 + n2 * d1, d1 * d2)
    defp subtract(%{num: n1, den: d1}, %{num: n2, den: d2}), do: new(n1 * d2 - n2 * d1, d1 * d2)
    defp multiply(%{num: n1, den: d1}, %{num: n2, den: d2}), do: new(n1 * n2, d1 * d2)
    defp divide(%{num: n1, den: d1}, %{num: n2, den: d2}) when n2 != 0, do: new(n1 * d2, d1 * n2)

    defp gcd(a, 0), do: a
    defp gcd(a, b), do: gcd(b, rem(a, b))

    defp zero, do: new(0)
    defp one, do: new(1)

    defp reduce({_, buttons, joltage}),
      do:
        buttons
        |> build_matrix(joltage)
        |> forward_substitution()
        |> search_minimal()

    defp build_matrix(buttons, joltages),
      do:
        Enum.with_index(joltages, fn joltage, index ->
          list = Enum.map(buttons, &map_button(index, &1))

          Enum.reverse([new(joltage) | Enum.reverse(list)])
        end)

    defp map_button(index, button) do
      if index in button do
        one()
      else
        zero()
      end
    end

    defp forward_substitution([first | _] = matrix) do
      {matrix, _, basic, free} =
        first
        |> Enum.with_index(fn _, index -> index end)
        |> Enum.drop(-1)
        |> Enum.reduce({matrix, [], [], []}, &forward_substitution/2)

      {matrix, basic, free}
    end

    defp forward_substitution(col, {matrix, touched, basic, free}),
      do: forward_substitution(matrix, col, touched, basic, free)

    defp forward_substitution(matrix, col, touched, basic, free) do
      case find_pivot(matrix, col, touched) do
        nil ->
          {matrix, touched, basic, [col | free]}

        {pivot_index, pivot_row, pivot_value} ->
          matrix =
            pivot_row
            |> scale_row(divide(one(), pivot_value))
            |> eliminate_column(matrix, pivot_index, col)

          {matrix, [pivot_index | touched], [{pivot_index, col} | basic], free}
      end
    end

    defp find_pivot(matrix, col, touched),
      do:
        matrix
        |> Enum.with_index(&{&2, &1, Enum.at(&1, col)})
        |> Enum.filter(fn {index, _, %{num: n}} -> abs(n) > 0 and index not in touched end)
        |> Enum.max_by(fn {_, _, %{num: n, den: d}} -> {abs(n), d} end, fn -> nil end)

    defp scale_row(row, factor), do: Enum.map(row, &multiply(&1, factor))

    defp eliminate_column(pivot_row, matrix, pivot_index, col),
      do:
        Enum.with_index(matrix, fn
          _, ^pivot_index ->
            pivot_row

          row, _ ->
            row
            |> Enum.at(col)
            |> subtract_rows(pivot_row, row)
        end)

    defp subtract_rows(factor, source_row, target_row),
      do:
        Enum.zip_with(source_row, target_row, fn s, t ->
          subtract(t, multiply(factor, s))
        end)

    defp search_minimal({matrix, basic, free}),
      do:
        Enum.reduce_while(0..@max_sum, {nil, @threshold}, fn target_sum, {best, count} ->
          case {best, count, find_solution(matrix, basic, free, target_sum)} do
            {nil, _, solution} -> {:cont, {solution, @threshold}}
            {_, 0, nil} -> {:halt, best}
            {_, _, nil} -> {:cont, {best, count - 1}}
            {_, _, solution} when solution < best -> {:cont, {solution, @threshold}}
            {_, _, _} -> {:cont, {best, @threshold}}
          end
        end)

    defp find_solution(matrix, basic, free, target),
      do:
        target
        |> partitions(free)
        |> Enum.reduce(nil, fn partition, best ->
          free
          |> Enum.zip(partition)
          |> Map.new()
          |> process_basic(matrix, basic)
          |> process_solution(best)
        end)

    defp process_solution({:ok, solution}, nil), do: solution
    defp process_solution({:ok, solution}, best) when solution < best, do: solution
    defp process_solution(_, best), do: best

    defp partitions(0, []), do: [[]]
    defp partitions(_, []), do: []
    defp partitions(n, _) when n < 0, do: []
    defp partitions(n, [_]), do: [[n]]

    defp partitions(n, [_ | tail]) do
      for i <- 0..n, rest <- partitions(n - i, tail) do
        [i | rest]
      end
    end

    defp process_basic(free, matrix, basic) do
      initial_solution = Enum.sum_by(free, &elem(&1, 1))

      Enum.reduce_while(basic, {:ok, initial_solution}, fn {row_index, _}, {:ok, sol} ->
        row = Enum.at(matrix, row_index)

        %{num: num, den: den} =
          row
          |> Enum.at(-1)
          |> subtract(sum_others(row, free))

        if num >= 0 and den === 1 do
          {:cont, {:ok, num + sol}}
        else
          {:halt, :invalid}
        end
      end)
    end

    defp sum_others(row, free),
      do:
        row
        |> Enum.with_index()
        |> Enum.filter(&is_map_key(free, elem(&1, 1)))
        |> Enum.reduce(zero(), fn {fraction, index}, acc ->
          free
          |> Map.fetch!(index)
          |> new()
          |> multiply(fraction)
          |> add(acc)
        end)
  end
end
