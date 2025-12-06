defmodule Aletopelta.Year2025.Day06 do
  @moduledoc """
  Day 6 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(list(binary() | :+ | :*)))
    def parse_input(input) do
      input
      |> Enum.map(&String.graphemes/1)
      |> parse_group([[], [], [], [], []])
    end

    defp parse_group([[] = a, a, a, a, a], acc) do
      Enum.map(acc, fn list ->
        list
        |> Enum.reverse()
        |> Enum.chunk_by(&(&1 === " "))
        |> Enum.reject(&(&1 === [" "]))
      end)
    end

    defp parse_group([[a | resta], [a | restb], [a | restc], [a | restd], [" " = a | reste]], [
           finala,
           finalb,
           finalc,
           finald,
           finale
         ]) do
      parse_group([resta, restb, restc, restd, reste], [
        [a | finala],
        [a | finalb],
        [a | finalc],
        [a | finald],
        finale
      ])
    end

    defp parse_group([[a | resta], [b | restb], [c | restc], [d | restd], liste], [
           finala,
           finalb,
           finalc,
           finald,
           finale
         ]) do
      [newa, newb, newc, newd] =
        Enum.map([a, b, c, d], fn
          " " -> "0"
          let -> let
        end)

      [e | reste] = extract_opeator(liste)

      parse_group([resta, restb, restc, restd, reste], [
        [newa | finala],
        [newb | finalb],
        [newc | finalc],
        [newd | finald],
        add_operator(e, finale)
      ])
    end

    defp extract_opeator([]), do: [" "]
    defp extract_opeator(list), do: list

    defp add_operator(" ", list), do: list
    defp add_operator(operator, list), do: Enum.concat(~w"#{operator}"a, list)

    @spec prepare_operation(atom(), list(list(binary()))) :: integer()
    def prepare_operation(operator, numbers) do
      numbers
      |> Enum.map(fn number ->
        number
        |> Enum.reject(&(&1 === "0"))
        |> Enum.join()
        |> String.to_integer()
      end)
      |> operation(operator)
    end

    defp operation(numbers, :+), do: Enum.sum(numbers)
    defp operation(numbers, :*), do: Enum.product(numbers)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop([a, b, c, d, [e]]), do: do_loop(0, [a, b, c, d, e])

    defp do_loop(number, [[] | _]), do: number

    defp do_loop(accumulator, [[a | resta], [b | restb], [c | restc], [d | restd], [e | reste]]),
      do:
        e
        |> Common.prepare_operation([a, b, c, d])
        |> Kernel.+(accumulator)
        |> do_loop([resta, restb, restc, restd, reste])
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop([a, b, c, d, [e]]), do: do_loop(0, [a, b, c, d, e])

    defp do_loop(number, [[] | _]), do: number

    defp do_loop(accumulator, [[a | resta], [b | restb], [c | restc], [d | restd], [e | reste]]) do
      e
      |> prepare_operation([a, b, c, d])
      |> Kernel.+(accumulator)
      |> do_loop([resta, restb, restc, restd, reste])
    end

    defp prepare_operation(operator, numbers) do
      numbers
      |> vertical()
      |> call_prepare(operator)
    end

    defp call_prepare(numbers, operator), do: Common.prepare_operation(operator, numbers)

    defp vertical([[], [], [], []]), do: []

    defp vertical([[a | resta], [b | restb], [c | restc], [d | restd]]),
      do: [[a, b, c, d] | vertical([resta, restb, restc, restd])]
  end
end
