defmodule Aletopelta.Year2024.Day05 do
  @moduledoc """
  Day 5 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """
    def parse_input(input) do
      input
      |> Enum.map(&String.split(&1, ~r/,|\|/))
      |> Enum.filter(&(length(&1) > 1))
      |> Enum.split_with(&(length(&1) == 2))
    end

    def fetch_rules(number, ordering_rules) do
      rules_after =
        ordering_rules
        |> Enum.filter(fn [first, _] -> first == number end)
        |> Enum.map(fn [_, second] -> second end)

      rules_before =
        ordering_rules
        |> Enum.filter(fn [_, second] -> second == number end)
        |> Enum.map(fn [first, _] -> first end)

      {number, rules_before, rules_after}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    def execute(input) do
      {ordering_rules, updates} = Common.parse_input(input)

      updates
      |> Enum.map(&process_update(&1, ordering_rules))
      |> Enum.filter(&valid_update?/1)
      |> Enum.map(&calculate_middle_number/1)
      |> Enum.sum()
    end

    defp process_update(update, ordering_rules) do
      update
      |> Enum.map(&Common.fetch_rules(&1, ordering_rules))
      |> Enum.with_index()
      |> Enum.map(&check_errors(&1, update))
    end

    defp check_errors({{number, rules_before, rules_after}, index}, update) do
      remaining_line_before = Enum.take(update, index)
      is_error_before = Enum.any?(rules_after, &Enum.member?(remaining_line_before, &1))

      remaining_line_after = Enum.drop(update, index + 1)
      is_error_after = Enum.any?(rules_before, &Enum.member?(remaining_line_after, &1))

      {number, is_error_before or is_error_after}
    end

    defp valid_update?(list) do
      result =
        list
        |> Enum.any?(&elem(&1, 1))

      not result
    end

    defp calculate_middle_number(list) do
      middle_index = div(length(list), 2)

      list
      |> Enum.map(&elem(&1, 0))
      |> Enum.at(middle_index)
      |> String.to_integer()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    def execute(input) do
      {ordering_rules, updates} = Common.parse_input(input)

      updates
      |> Enum.map(&process_update(&1, ordering_rules))
      |> Enum.filter(&valid_update?/1)
      |> Enum.map(&correct_errors(&1, ordering_rules))
      |> Enum.map(&calculate_middle_number/1)
      |> Enum.sum()
    end

    defp process_update(update, ordering_rules) do
      update
      |> Enum.map(&Common.fetch_rules(&1, ordering_rules))
      |> Enum.with_index()
      |> Enum.map(&check_errors(&1, update))
    end

    defp check_errors({{number, rules_before, rules_after}, index}, update) do
      remaining_line_before = Enum.take(update, index)
      is_error_before = Enum.any?(rules_after, &Enum.member?(remaining_line_before, &1))

      remaining_line_after = Enum.drop(update, index + 1)
      is_error_after = Enum.any?(rules_before, &Enum.member?(remaining_line_after, &1))

      {number, is_error_before or is_error_after, update}
    end

    defp valid_update?(list) do
      list
      |> Enum.any?(&elem(&1, 1))
    end

    defp calculate_middle_number(list) do
      middle_index = div(length(list), 2)

      list
      |> Enum.at(middle_index)
      |> String.to_integer()
    end

    defp correct_errors(list, ordering_rules) do
      result =
        list
        |> Enum.filter(&elem(&1, 1))
        |> Enum.map(&elem(&1, 2))

      result =
        result
        |> Enum.at(0)

      result =
        result
        |> Enum.map(&Common.fetch_rules(&1, ordering_rules))

      build_update(result)
    end

    defp build_update([head]), do: [elem(head, 0)]

    defp build_update([head | rest]) do
      number = elem(head, 0)

      is_number_in_rules =
        rest
        |> Enum.flat_map(&elem(&1, 2))
        |> Enum.uniq()
        |> Enum.any?(&(&1 == number))

      if is_number_in_rules do
        build_update(rest ++ [head])
      else
        [number] ++ build_update(rest)
      end
    end
  end
end
