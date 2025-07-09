defmodule Aletopelta.Year2020.Day10 do
  @moduledoc """
  Day 10 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_chain()
      |> product()
    end

    defp product({nb1, nb3}), do: nb1 * nb3

    defp do_chain(numbers), do: do_chain(numbers, 0, {0, 1})
    defp do_chain([], _, acc), do: acc

    defp do_chain([number | numbers], last, {nb1, nb3}) when number - last == 1,
      do: do_chain(numbers, number, {nb1 + 1, nb3})

    defp do_chain([number | numbers], last, {nb1, nb3}) when number - last == 3,
      do: do_chain(numbers, number, {nb1, nb3 + 1})

    defp do_chain([number | numbers], _, acc), do: do_chain(numbers, number, acc)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Map.new(&{&1, 1})
      |> do_chain()
      |> elem(1)
    end

    defp do_chain(numbers) do
      max =
        numbers
        |> Enum.max_by(&elem(&1, 0))
        |> elem(0)

      do_chain(numbers, 0, Map.new(), max)
    end

    defp before_chain(numbers, {number, _} = key, cache, max) do
      case Map.fetch(cache, key) do
        {:ok, value} ->
          {cache, value}

        :error ->
          {alt_cache, value} = do_chain(numbers, number, cache, max)
          new_cache = Map.put(alt_cache, key, value)
          {new_cache, value}
      end
    end

    defp do_chain(_, max, cache, max), do: {cache, 1}

    defp do_chain(numbers, number, cache, max) do
      [1, 2, 3]
      |> Enum.map(&{&1 + number, &1})
      |> Enum.filter(&valid_number?(numbers, &1, max))
      |> Enum.reduce({cache, 0}, fn subnumber, {cache_acc, sum_acc} ->
        {new_cache, new_sum} = before_chain(numbers, subnumber, cache_acc, max)
        {new_cache, sum_acc + new_sum}
      end)
    end

    defp valid_number?(_, {max, 3}, max), do: true
    defp valid_number?(numbers, {number, _}, _), do: Map.has_key?(numbers, number)
  end
end
