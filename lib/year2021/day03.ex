defmodule Aletopelta.Year2021.Day03 do
  @moduledoc """
  Day 3 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """
    @spec parse_input([binary()]) :: [[{0, 1} | {1, 0}]]
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.graphemes()
        |> Enum.map(fn
          "1" -> {0, 1}
          "0" -> {1, 0}
        end)
      end)
    end

    @spec to_decimal([binary()]) :: integer()
    def to_decimal(binary) do
      binary
      |> Enum.reverse()
      |> Enum.with_index(fn digit, power ->
        String.to_integer(digit) * 2 ** power
      end)
      |> Enum.sum()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> get_frequent()
      |> separate_number()
      |> Enum.map(&Common.to_decimal/1)
      |> Enum.product()
    end

    defp separate_number([]), do: [[], []]

    defp separate_number([{zero, one} | others]) when zero > one do
      [number1, number2] = separate_number(others)
      [["0" | number1], ["1" | number2]]
    end

    defp separate_number([{_, _} | others]) do
      [number1, number2] = separate_number(others)
      [["1" | number1], ["0" | number2]]
    end

    defp get_frequent([number]), do: number

    defp get_frequent([number1, number2 | others]) do
      frequent = get_frequent(number1, number2)
      get_frequent([frequent | others])
    end

    defp get_frequent([], []), do: []

    defp get_frequent([{zero1, one1} | rest1], [{zero2, one2} | rest2]) do
      [{zero1 + zero2, one1 + one2} | get_frequent(rest1, rest2)]
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> get_wrapper()
      |> Enum.map(&Common.to_decimal/1)
      |> Enum.product()
    end

    defp get_wrapper([[]]), do: []

    defp get_wrapper(numbers) do
      frequent = get_frequent(numbers)

      Enum.map([:oxy, :co2], fn style ->
        loop_suite =
          frequent
          |> get_numbers(numbers, style)
          |> get_wrapper(style)

        build_number([frequent | loop_suite], style)
      end)
    end

    defp build_number([], _), do: []
    defp build_number([{0, 1} | others], style), do: ["1" | build_number(others, style)]
    defp build_number([{1, 0} | others], style), do: ["0" | build_number(others, style)]

    defp build_number([{zero, one} | others], :oxy) when zero > one,
      do: ["0" | build_number(others, :oxy)]

    defp build_number([_ | others], :oxy), do: ["1" | build_number(others, :oxy)]

    defp build_number([{zero, one} | others], :co2) when zero > one,
      do: ["1" | build_number(others, :co2)]

    defp build_number([_ | others], :co2), do: ["0" | build_number(others, :co2)]

    defp get_wrapper([[]], _), do: []
    defp get_wrapper([number], _), do: number

    defp get_wrapper(numbers, style) do
      frequent = get_frequent(numbers)

      new_suite =
        frequent
        |> get_numbers(numbers, style)
        |> get_wrapper(style)

      [frequent | new_suite]
    end

    defp get_numbers({zero, one}, numbers, :oxy) when zero > one, do: do_filter(numbers, {1, 0})
    defp get_numbers(_, numbers, :oxy), do: do_filter(numbers, {0, 1})
    defp get_numbers({zero, one}, numbers, :co2) when zero > one, do: do_filter(numbers, {0, 1})
    defp get_numbers(_, numbers, :co2), do: do_filter(numbers, {1, 0})

    defp do_filter(numbers, keep) do
      numbers
      |> Enum.filter(fn
        [^keep | _] -> true
        _ -> false
      end)
      |> Enum.map(&Enum.drop(&1, 1))
    end

    defp get_frequent([[number]]), do: number

    defp get_frequent([number1, number2 | others]) do
      frequent = get_frequent(number1, number2)
      get_frequent([frequent | others])
    end

    defp get_frequent([{zero1, one1} | _], [{zero2, one2} | _]) do
      [{zero1 + zero2, one1 + one2}]
    end
  end
end
