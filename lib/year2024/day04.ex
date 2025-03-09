defmodule Aletopelta.Year2024.Day04 do
  @moduledoc """
  Day 4 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    def execute(input) do
      result = input
      |> Enum.map(&count_horizontal("XMAS", &1))
      |> Enum.sum()

      result = result + (input
      |> Enum.map(&count_horizontal("SAMX", &1))
      |> Enum.sum())

      transpose = input
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join/1)

      result = result + (transpose
      |> Enum.map(&count_horizontal("XMAS", &1))
      |> Enum.sum())

      result = result + (transpose
      |> Enum.map(&count_horizontal("SAMX", &1))
      |> Enum.sum())

      result = result + find_diagonal("XMAS", input)
      result + find_diagonal("SAMX", input)
    end

    defp count_horizontal(word, string) do
      pattern = Regex.compile!("#{word}")

      Regex.scan(pattern, string) |> Enum.count()
    end

    defp find_diagonal(word, list, direction \\ :both, position \\ 0, idx \\ -2)
    defp find_diagonal(_, [], _, _, _), do: 0
    defp find_diagonal(word, [head | tail], direction, position, idx) do
        relevent_chars = get_relevant_chars(head, word, position, idx)

        result = cond do
          Enum.count(relevent_chars) < 1 -> 0
          String.length(word) == position + 1 -> 1
          true -> follow_direction(relevent_chars, word, tail, direction, position)
        end

        case position do
          0 -> result + find_diagonal(word, tail, direction, position, idx)
          _ -> result
        end
    end

    defp get_relevant_chars(row, word, position, idx) do
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, i} ->
        (idx < -1 or idx == i) and char == String.at(word, position)
      end)
    end

    defp adjust_index(i, :+), do: i + 1
    defp adjust_index(i, _), do: i - 1

    defp follow_direction(chars, word, tail, :both, position) do
      follow_direction(chars, word, tail, :+, position) + follow_direction(chars, word, tail, :-, position)
    end

    defp follow_direction(chars, word, tail, direction, position) do
      chars
      |> Enum.map(fn {_, i} -> adjust_index(i, direction) end)
      |> Enum.map(&find_diagonal(word, tail, direction, position + 1, &1))
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    def execute(input) do
      search_x(String.graphemes("MAS"), input)
    end

    defp search_x(_, [_, _]), do: 0
    defp search_x([first_letter, middle_letter, last_letter], [layer1, layer2, layer3 | rest]) do
      middle_letter_positions = layer2
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(fn {letter, _} -> middle_letter == letter end)

      result = if Enum.count(middle_letter_positions) > 0 do
        middle_letter_positions
        |> Enum.map(&check_positions(&1, first_letter, last_letter, layer1, layer3))
        |> Enum.sum()
      else
        0
      end

      result + search_x([first_letter, middle_letter, last_letter], [layer2, layer3 | rest])
    end

    defp check_positions({_, middle_index}, first_letter, last_letter, layer1, layer3) do
      top_positions = get_positions(layer1, middle_index, first_letter, last_letter)
      bottom_positions = get_positions(layer3, middle_index, first_letter, last_letter)

      combined_positions = top_positions
      |> Enum.filter(fn {top_letter, bottom_letter} -> count_bottom_matches(bottom_positions, top_letter, bottom_letter) == 1 end)

      if Enum.count(combined_positions) == 2, do: 1, else: 0
    end

    defp get_positions(layer, middle_index, first_letter, last_letter) do
      layer
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(fn {letter, index} -> (letter == first_letter or letter == last_letter) and abs(index - middle_index) == 1 end)
    end

    defp count_bottom_matches(bottom_positions, top_letter, top_index) do
      bottom_positions
      |> Enum.count(fn {bottom_letter, bottom_index} -> bottom_index != top_index and bottom_letter != top_letter end)
    end
  end
end
