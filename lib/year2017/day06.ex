defmodule Aletopelta.Year2017.Day06 do
  @moduledoc """
  Day 6 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list({integer(), integer()})
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split()
      |> Enum.with_index(&{String.to_integer(&1), &2})
    end

    @spec balance(list({integer(), integer()})) :: {integer(), integer()}
    def balance(banks), do: prebalance(banks, Enum.count(banks), Map.new(), 0)

    defp prebalance(old_banks, count, seen, cycle) do
      banks = Enum.sort_by(old_banks, &elem(&1, 1))
      joined = Enum.map_join(banks, &elem(&1, 0))

      case Map.get(seen, joined) do
        nil ->
          new_seen = Map.put(seen, joined, cycle)

          banks
          |> do_balance(count)
          |> prebalance(count, new_seen, cycle + 1)

        initial ->
          {cycle, cycle - initial}
      end
    end

    defp do_balance(banks, count) do
      {block, index} = Enum.max_by(banks, fn {blocks, index} -> {blocks, -index} end)
      {left, [_ | right]} = Enum.split_while(banks, fn {_, bindex} -> bindex < index end)

      value = div(block, count)

      right
      |> Enum.concat(left)
      |> Enum.concat([{0, index}])
      |> Enum.map_reduce(rem(block, count), &update_block(&1, &2, value))
      |> elem(0)
    end

    defp update_block({block, index}, 0, value), do: {{block + value, index}, 0}
    defp update_block({block, index}, acc, value), do: {{block + value + 1, index}, acc - 1}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.balance()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.balance()
      |> elem(1)
    end
  end
end
