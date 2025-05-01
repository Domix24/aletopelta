defmodule Aletopelta.Year2022.Day20 do
  @moduledoc """
  Day 20 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """
    @spec parse_input(list(binary())) :: list(integer())
    def parse_input(input) do
      Enum.map(input, &String.to_integer/1)
    end

    @spec mix_file(list(integer()), integer(), integer()) :: integer()
    def mix_file(numbers, decryption_key, rounds) do
      indexed_numbers =
        numbers
        |> Enum.map(&(&1 * decryption_key))
        |> Enum.with_index()

      list_length = length(indexed_numbers)
      original_order = indexed_numbers

      final_list =
        Enum.reduce(1..rounds, indexed_numbers, fn _, acc ->
          mix_round(acc, original_order)
        end)

      zero_index = Enum.find_index(final_list, fn {num, _} -> num == 0 end)

      [1000, 2000, 3000]
      |> Enum.map(fn offset ->
        index = rem(zero_index + offset, list_length)
        {value, _} = Enum.at(final_list, index)
        value
      end)
      |> Enum.sum()
    end

    defp mix_round(current_list, original_order) do
      Enum.reduce(original_order, current_list, fn {value, original_idx}, acc ->
        current_idx = Enum.find_index(acc, fn {_, idx} -> idx == original_idx end)

        if value == 0 do
          acc
        else
          {item, temp_list} = List.pop_at(acc, current_idx)

          effective_size = length(temp_list)
          moves = rem(value, effective_size)

          new_idx = calculate_new_index(current_idx, moves, effective_size)
          List.insert_at(temp_list, new_idx, item)
        end
      end)
    end

    defp calculate_new_index(current_idx, moves, size) do
      new_idx = current_idx + moves

      cond do
        new_idx >= size ->
          rem(new_idx, size)

        new_idx < 0 ->
          size + rem(new_idx, size)

        true ->
          new_idx
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.mix_file(1, 1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.mix_file(811_589_153, 10)
    end
  end
end
