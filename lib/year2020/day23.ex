defmodule Aletopelta.Year2020.Day23 do
  @moduledoc """
  Day 23 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: list(binary())
    @type output() :: list(integer())

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end

    defp build_next([first | _] = list) do
      list
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce({Map.new(), nil}, fn
        [val, next], {acc_map, nil} -> {Map.put(acc_map, val, next), nil}
        [val], {acc_map, nil} -> {Map.put(acc_map, val, first), val}
      end)
    end

    @spec play(output(), integer()) :: %{integer() => integer()}
    def play(list, nb_move) do
      {next, current} = build_next(list)

      number_range =
        next
        |> Enum.min_max_by(&elem(&1, 0))
        |> then(fn {{min, _}, {max, _}} -> min..max//1 end)

      1..nb_move
      |> Enum.reduce({next, current}, &reduce_moves(&1, &2, number_range))
      |> elem(0)
    end

    defp reduce_moves(_, {acc_next, acc_current}, number_range) do
      new_current = Map.fetch!(acc_next, acc_current)
      destination = transform(new_current - 1, number_range)
      new_pick1 = Map.fetch!(acc_next, new_current)
      new_pick2 = Map.fetch!(acc_next, new_pick1)
      new_pick3 = Map.fetch!(acc_next, new_pick2)
      new_pick4 = Map.fetch!(acc_next, new_pick3)

      new_destination =
        find_destination([new_pick1, new_pick2, new_pick3], destination, number_range)

      next_destination = Map.fetch!(acc_next, new_destination)

      new_next =
        acc_next
        |> Map.put(new_current, new_pick4)
        |> Map.put(new_destination, new_pick1)
        |> Map.put(new_pick3, next_destination)

      {new_next, new_current}
    end

    defp transform(number, min..max//1) when number in min..max//1, do: number
    defp transform(_, _..max//1), do: max

    defp find_destination([number, _, _] = picks, number, number_range),
      do: find_destination(picks, transform(number - 1, number_range), number_range)

    defp find_destination([_, number, _] = picks, number, number_range),
      do: find_destination(picks, transform(number - 1, number_range), number_range)

    defp find_destination([_, _, number] = picks, number, number_range),
      do: find_destination(picks, transform(number - 1, number_range), number_range)

    defp find_destination(_, number, _), do: number
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.play(100)
      |> build_result()
      |> String.to_integer()
    end

    defp build_result(next) do
      build_result(next, [], 1)
    end

    defp build_result(_, [1 | string], _),
      do:
        string
        |> Enum.reverse()
        |> Enum.join("")

    defp build_result(next, string, value) do
      next_value = Map.fetch!(next, value)
      build_result(next, [next_value | string], next_value)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> increase_input()
      |> Common.play(10_000_000)
      |> prepare_result()
    end

    defp increase_input(list) do
      list ++ Range.to_list(10..1_000_000)
    end

    defp prepare_result(next) do
      first_cup = Map.fetch!(next, 1)
      second_cup = Map.fetch!(next, first_cup)

      first_cup * second_cup
    end
  end
end
