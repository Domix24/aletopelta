defmodule Aletopelta.Day20241202 do 
  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Enum.map(&convert_to_integers/1)
      |> Enum.map(&assess_safety/1)
      |> Enum.filter(&(&1 == "safe"))
      |> Enum.count()
    end

    defp convert_to_integers(list_of_lists) do
      Enum.map(list_of_lists, &String.to_integer/1)
    end

    defp assess_safety(numbers) do
      chunks = Enum.chunk_every(numbers, 2, 1, :discard)
      direction_check = determine_direction(Enum.at(numbers, 0), Enum.at(numbers, 1))

      has_conflicting_signs = chunks |> Enum.any?(&(direction_check.(Enum.at(&1, 0), Enum.at(&1, 1))))
      
      has_conflicting_signs = if not has_conflicting_signs do
        Enum.any?(chunks, &has_invalid_difference?/1)
      else
        has_conflicting_signs
      end

      if has_conflicting_signs, do: "unsafe", else: "safe"
    end

    defp determine_direction(first, second) do
      if first < second, do: &(&1 > &2), else: &(&2 > &1)
    end

    defp has_invalid_difference?(chunk) do
      difference = abs(Enum.at(chunk, 0) - Enum.at(chunk, 1))
      difference <= 0 or difference >= 4
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      input
      |> Enum.map(&convert_to_integers/1)
      |> Enum.map(&evaluate_safety/1)
      |> Enum.filter(&(&1 == "safe"))
      |> Enum.count()
    end

    defp convert_to_integers(list_of_lists) do
      Enum.map(list_of_lists, &String.to_integer/1)
    end

    defp assess_safety(numbers) do
      chunks = Enum.chunk_every(numbers, 2, 1, :discard)
      direction_check = determine_direction(Enum.at(numbers, 0), Enum.at(numbers, 1))

      has_conflicting_signs = chunks |> Enum.any?(&(direction_check.(Enum.at(&1, 0), Enum.at(&1, 1))))
      
      has_conflicting_signs = if not has_conflicting_signs do
        Enum.any?(chunks, &has_invalid_difference?/1)
      else
        has_conflicting_signs
      end

      if has_conflicting_signs, do: "unsafe", else: "safe"
    end

    defp evaluate_safety(numbers) do
      case assess_safety(numbers) do
        "safe" -> "safe"
        "unsafe" ->
          safety_result = numbers
            |> Enum.with_index()
            |> Enum.map(fn {_, index} -> 
              {updated_left, [_ | updated_right]} = Enum.split(numbers, index)
              assess_safety(updated_left ++ updated_right)
            end)

          if Enum.any?(safety_result, &(&1 == "safe")), do: "safe", else: "unsafe"
      end
    end

    defp determine_direction(first, second) do
      if first < second, do: &(&1 > &2), else: &(&2 > &1)
    end

    defp has_invalid_difference?(chunk) do
      difference = abs(Enum.at(chunk, 0) - Enum.at(chunk, 1))
      difference <= 0 or difference >= 4
    end
  end
end
