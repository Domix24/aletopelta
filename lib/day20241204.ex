defmodule Aletopelta.Day20241204 do 
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
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
      |> Enum.filter(fn {_, i} -> idx < -1 or idx == i end)
      |> Enum.filter(fn {char, _} -> char == String.at(word, position) end)
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
    def execute(_input \\ nil), do: 2
  end
end
