defmodule Aletopelta.Year2023.Day01 do
  @moduledoc """
  Day 1 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """
    def parse_input([], _), do: []
    def parse_input([first | others], find_numbers) do
      [parse_line(first, find_numbers) | parse_input(others, find_numbers)]
    end

    defp parse_line(line, find_numbers) do
      line
      |> String.graphemes
      |> find_numbers.()
    end

    def digit?(grapheme) do
      case Integer.parse(grapheme) do
        :error -> false
        _ -> true
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    def execute(input) do
      Common.parse_input(input, &find_numbers/1)
      |> Enum.map(&Enum.join/1)
      |> Enum.sum_by(&String.to_integer/1)
    end

    defp find_numbers(graphemes, number1 \\ nil, number2 \\ nil)
    defp find_numbers([], number1, nil), do: [number1, number1]
    defp find_numbers([], number1, number2), do: [number1, number2]
    defp find_numbers([first | others], nil, number2) do
      if Common.digit?(first) do
        find_numbers(others, first)
      else
        find_numbers(others, nil, number2)
      end
    end
    defp find_numbers([first | others], number1, number2) do
      if Common.digit?(first) do
        find_numbers(others, number1, first)
      else
        find_numbers(others, number1, number2)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    def execute(input) do
      Common.parse_input(input, &find_numbers/1)
      |> Enum.map(&Enum.join/1)
      |> Enum.sum_by(&String.to_integer/1)
    end

    defp find_numbers(graphemes, number1 \\ nil, number2 \\ nil, textual \\ "")
    defp find_numbers([], number1, nil, _), do: [number1, number1]
    defp find_numbers([], number1, number2, _), do: [number1, number2]
    defp find_numbers([first | others], nil, number2, textual) do
      {state, textual} = "#{textual}#{first}"
      |> get_state

      cond do
        Common.digit?(first) -> find_numbers(others, first)
        state == :complete -> find_numbers(add_letter(others, textual), textual)
        state == :partial -> find_numbers(others, nil, number2, textual)
        true -> find_numbers(others)
      end
    end
    defp find_numbers([first | others], number1, number2, textual) do
      {state, textual} = "#{textual}#{first}"
      |> get_state

      cond do
        Common.digit?(first) -> find_numbers(others, number1, first)
        state == :complete -> find_numbers(add_letter(others, textual), number1, textual)
        state == :partial -> find_numbers(others, number1, number2, textual)
        true -> find_numbers(others, number1, number2)
      end
    end

    defp get_state("one"),   do: {:complete, "1"}
    defp get_state("two"),   do: {:complete, "2"}
    defp get_state("three"), do: {:complete, "3"}
    defp get_state("four"),  do: {:complete, "4"}
    defp get_state("five"),  do: {:complete, "5"}
    defp get_state("six"),   do: {:complete, "6"}
    defp get_state("seven"), do: {:complete, "7"}
    defp get_state("eight"), do: {:complete, "8"}
    defp get_state("nine"),  do: {:complete, "9"}
    defp get_state(text) do
      case Regex.scan(~r/(o|on|t|tw|th|thr|thre|f|fo|fou|fi|fiv|s|si|se|sev|seve|e|ei|eig|eigh|n|ni|nin)$/, text, capture: :first) do
        [] -> {:error, ""}
        [[letters]] -> {:partial, letters}
      end
    end

    defp add_letter(others, "1"), do: ["e" | others]
    defp add_letter(others, "2"), do: ["o" | others]
    defp add_letter(others, "3"), do: ["e" | others]
    defp add_letter(others, "5"), do: ["e" | others]
    defp add_letter(others, "7"), do: ["n" | others]
    defp add_letter(others, "8"), do: ["t" | others]
    defp add_letter(others, "9"), do: ["e" | others]
    defp add_letter(others, _),   do: others
  end
end
