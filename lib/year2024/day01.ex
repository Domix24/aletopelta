defmodule Aletopelta.Year2024.Day01 do
  @moduledoc """
  Day 1 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """
    def parse_input(input) do
      Enum.flat_map(input, fn line ->
        [[number1], [number2]] = Regex.scan(~r/\d+/, line)
        [number1, number2] |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    def execute(input) do
      Common.parse_input(input) |> process_numbers
    end

    defp process_numbers(numbers) do
      {even, odd} = split_even_odd(numbers)

      differences = calculate_differences(even, odd)

      Enum.sum(differences)
    end

    defp split_even_odd(list) do
      indexed_list = Enum.with_index(list)

      {evens, odds} = Enum.split_with(indexed_list, fn {_, index} -> rem(index, 2) == 0 end)

      even_elements = Enum.map(evens, &elem(&1, 0)) |> Enum.sort()
      odd_elements = Enum.map(odds, &elem(&1, 0)) |> Enum.sort()

      {even_elements, odd_elements}
    end

    defp calculate_differences(even, odd) do
      Enum.with_index(even) |> Enum.map(fn {value, index} -> abs(value - Enum.at(odd, index)) end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    def execute(input) do
      Common.parse_input(input) |> process_numbers
    end

    def process_numbers(numbers) do
      {even, odd} = split_even_odd(numbers)

      occurences = calculate_occurences(even, odd)

      Enum.sum(occurences)
    end

    defp split_even_odd(list) do
      indexed_list = Enum.with_index(list)

      {evens, odds} = Enum.split_with(indexed_list, fn {_, index} -> rem(index, 2) == 0 end)

      even_elements = Enum.map(evens, &elem(&1, 0))
      odd_elements = Enum.map(odds, &elem(&1, 0))

      {even_elements, odd_elements}
    end

    defp calculate_occurences(even, odd) do
      Enum.map(even, fn element -> element * Enum.count(odd, &(&1 == element)) end)
    end
  end
end
