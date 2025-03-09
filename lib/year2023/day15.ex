defmodule Aletopelta.Year2023.Day15 do
  @moduledoc """
  Day 15 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """
    def parse_input(input) do
      Enum.at(input, 0)
      |> String.split(",")
    end

    def process_hash hash do
      String.graphemes(hash)
      |> Enum.reduce(0, fn <<character::utf8>>, acc ->
        rem (acc + character) * 17, 256
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    def execute(input) do
      Common.parse_input(input)
      |> process_hash
    end

    defp process_hash [] do
      0
    end
    defp process_hash [first | others] do
      Common.process_hash(first)
      |> then(& &1 + process_hash(others))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    def execute(input) do
      Common.parse_input(input)
      |> do_loop
      |> Enum.sum_by(&get_boxpower/1)
    end

    defp get_boxpower {box_number, slots}  do
      get_lenspower slots, box_number, 1
    end

    defp calcutate_power box_number, slot_index, power do
      (box_number + 1) * slot_index * power
    end

    defp get_lenspower [], _, _ do
      0
    end
    defp get_lenspower [{_, power} | others], box_number, slot_index do
      calcutate_power(box_number, slot_index, power) + get_lenspower(others, box_number, slot_index + 1)
    end

    defp do_loop input do
      Enum.reduce input, %{}, fn full_hash, boxes ->
        [hash, info] = String.split full_hash, ~r/-|=/
        number = Common.process_hash hash

        case info do
          "" ->
            Map.update boxes, number, [], &remove_lens(&1, hash)
          _ ->
            power = String.to_integer info
            Map.update boxes, number, [{hash, power}], &replace_lens(&1, power, hash)
        end
      end
    end

    defp remove_lens [], _ do
      []
    end
    defp remove_lens [{value, _} | others], value do
      others
    end
    defp remove_lens [first | others], value do
      [first | remove_lens(others, value)]
    end

    defp replace_lens [], full, value do
      [{value, full}]
    end
    defp replace_lens [{value, _} | others], full, value do
      [{value, full} | others]
    end
    defp replace_lens [first | others], full, value do
      [first | replace_lens(others, full, value)]
    end
  end
end
