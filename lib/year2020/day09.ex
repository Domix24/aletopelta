defmodule Aletopelta.Year2020.Day09 do
  @moduledoc """
  Day 9 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec prepare_loop(list(integer())) :: integer()
    def prepare_loop(numbers) do
      {first_25, rest} = Enum.split(numbers, 25)
      do_loop(rest, first_25)
    end

    defp do_loop([number | rest], [_ | new_25] = before_25) do
      if sum_two(number, before_25) do
        do_loop(rest, Enum.reverse([number | Enum.reverse(new_25)]))
      else
        number
      end
    end

    defp sum_two(number, list) do
      for num1 <- list,
          num2 <- list,
          number == num1 + num2,
          reduce: false do
        _ -> true
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
    end

    defp prepare_loop(numbers) do
      invalid = Common.prepare_loop(numbers)
      do_loop(numbers, invalid, [])
    end

    defp do_loop([number | numbers], invalid, acc) do
      sum = Enum.sum(acc)

      cond do
        sum == invalid ->
          {min, max} = Enum.min_max(acc)
          min + max

        sum + number < invalid ->
          do_loop(numbers, invalid, [number | acc])

        true ->
          new_acc = reduce_acc(acc, sum, number, invalid)
          do_loop(numbers, invalid, new_acc)
      end
    end

    defp reduce_acc(acc, sum, number, invalid) do
      [out_number | reversed] = Enum.reverse(acc)

      if sum - out_number + number > invalid do
        reversed
        |> Enum.reverse()
        |> reduce_acc(sum - out_number, number, invalid)
      else
        [number | Enum.reverse(reversed)]
      end
    end
  end
end
