defmodule Aletopelta.Year2024.Day19 do
  @moduledoc """
  Day 19 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """
    def parse_input(input) do
      towels = input |> Enum.at(0) |> String.split(", ")
      designs = input |> Enum.drop(2) |> Enum.reject(& &1 == "")

      {towels, designs}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    def execute(input) do
      {towels, designs} = Common.parse_input(input)

      Enum.count(designs, &valid?(&1, towels))
    end

    defp valid?("", _), do: true
    defp valid?(design, towels) do
      Enum.any?(towels, fn towel ->
        String.starts_with?(design, towel) and valid?(String.trim_leading(design, towel), towels)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    def execute(input) do
      {towels, designs} = Common.parse_input(input)

      designs |> Enum.map(&count_valid_combinations(&1, towels)) |> Enum.sum
    end

    defp count_valid_combinations(design, towels) do
      {result, _} = count_combinations(design, towels, %{})
      result
    end

    defp count_combinations("", _, memo), do: {1, memo}
    defp count_combinations(design, towels, memo) do
      memo_key = design

      case Map.fetch(memo, memo_key) do
        {:ok, value} -> {value, memo}
        :error ->
          {result, updated_memo} = Enum.reduce(towels, {0, memo}, fn towel, {acc, memo} ->
            update_result acc, towel, design, memo, towels
          end)

          final_memo = Map.put(updated_memo, memo_key, result)
          {result, final_memo}
      end
    end

    defp update_result acc, towel, design, memo, towels do
      if String.starts_with?(design, towel) do
        {res, new_memo} = count_combinations(String.slice(design, String.length(towel), String.length(design)), towels, memo)
        {acc + res, new_memo}
      else
        {acc, memo}
      end
    end
  end
end
