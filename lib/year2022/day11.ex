defmodule Aletopelta.Year2022.Day11 do
  @moduledoc """
  Day 11 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """
    @spec parse_input(list()) :: map()
    def parse_input(input) do
      input
      |> Stream.chunk_by(&(&1 == ""))
      |> Stream.reject(&(&1 == [""]))
      |> Stream.map(&parse_line/1)
      |> Map.new()
    end

    defp parse_line([monkey, items, operation, test, test_true, test_false]) do
      [monkey_number, monkey_test, monkey_true, monkey_false] =
        parse_numbers(monkey, test, test_true, test_false)

      monkey_items = parse_items(items)
      monkey_operation = parse_operation(operation)

      {monkey_number, {monkey_items, monkey_operation, monkey_test, monkey_true, monkey_false, 0}}
    end

    defp parse_items(items) do
      ~r/\d+/
      |> Regex.scan(items)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.to_integer/1)
    end

    defp parse_numbers(monkey, test, test_true, test_false) do
      [monkey, test, test_true, test_false]
      |> Enum.map(&Regex.scan(~r/\d+/, &1))
      |> Enum.flat_map(& &1)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.to_integer/1)
    end

    defp parse_operation(operation) do
      ~r/\S+/
      |> Regex.scan(operation)
      |> Enum.drop(3)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn line ->
        if String.match?(line, ~r/\d+/) do
          String.to_integer(line)
        else
          line
        end
      end)
    end

    @spec process_rounds(any(), keyword()) :: integer()
    def process_rounds(monkeys, opts) do
      1..opts[:rounds]//1
      |> Enum.reduce(monkeys, fn _, monkeys ->
        process_round(monkeys, opts)
      end)
      |> Enum.map(fn {_, {_, _, _, _, _, count}} -> count end)
      |> Enum.sort(:desc)
      |> Enum.take(2)
      |> Enum.reduce(&(&1 * &2))
    end

    defp process_round(monkeys, opts) do
      Enum.reduce(monkeys, monkeys, fn {number, monkey}, monkeys ->
        monkeys
        |> get_items(number)
        |> process_monkey(monkeys, number, monkey, opts)
      end)
    end

    defp get_items(monkeys, number) do
      monkeys
      |> Map.fetch!(number)
      |> elem(0)
    end

    defp process_monkey(
           items,
           monkeys,
           number,
           {_, operation, test, yes, no, count} = monkey,
           opts
         ) do
      items
      |> Enum.map(&process_item(monkey, &1, opts))
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.reduce(monkeys, &update_monkeys/2)
      |> Map.put(number, {[], operation, test, yes, no, count + length(items)})
    end

    defp update_monkeys({monkey, items}, monkeys) do
      Map.update!(monkeys, monkey, fn {monkey_items, operation, test, yes, no, count} ->
        {monkey_items ++ items, operation, test, yes, no, count}
      end)
    end

    defp process_item({_, operation, test, yes, no, _}, item, opts) do
      item
      |> update_worry(operation)
      |> divide_worry(opts[:divide])
      |> reduce_worry(opts[:divide], opts[:divisor])
      |> execute_test(test)
      |> launch_item(yes, no)
    end

    defp update_worry(worry, operation) do
      [first, operator, second] =
        Enum.map(operation, fn
          "old" -> worry
          "*" -> &Kernel.*/2
          "+" -> &Kernel.+/2
          number when is_integer(number) -> number
        end)

      operator.(first, second)
    end

    defp divide_worry(worry, true), do: div(worry, 3)
    defp divide_worry(worry, false), do: worry

    defp reduce_worry(worry, true, _), do: worry
    defp reduce_worry(worry, false, divisor), do: rem(worry, divisor)

    defp execute_test(worry, test), do: {worry, rem(worry, test) == 0}

    defp launch_item({worry, true}, yes, _), do: {yes, worry}
    defp launch_item({worry, false}, _, no), do: {no, worry}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.process_rounds(rounds: 20, divide: true)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> find_divisor()
      |> process_rounds(rounds: 10_000, divide: false)
    end

    defp find_divisor(input) do
      divisor =
        Enum.reduce(input, 1, fn {_, {_, _, test, _, _, _}}, result ->
          result * test
        end)

      {input, divisor}
    end

    defp process_rounds({input, divisor}, opts) do
      Common.process_rounds(input, Keyword.merge(opts, divisor: divisor))
    end
  end
end
