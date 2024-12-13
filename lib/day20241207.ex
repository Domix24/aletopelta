defmodule Aletopelta.Day20241207 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Enum.filter(&(&1 != ""))
      |> Enum.reduce(0, fn list, acc ->
        [goal | numbers] = list
        |> String.split(~r/:| /, trim: true)
        |> Enum.map(&String.to_integer/1)

        acc + process_line(goal, numbers)
      end)
    end

    defp process_line(goal, [first, second], :+) when first + second == goal, do: goal
    defp process_line(goal, [first, second], :*) when first * second == goal, do: goal

    defp process_line(_goal, [_first, _second], _operator), do: 0

    defp process_line(goal, [first, second | rest], :+), do: process_line(goal, [first + second | rest])
    defp process_line(goal, [first, second | rest], :*), do: process_line(goal, [first * second | rest])

    defp process_line(goal, [first, second | rest]) when first + second > goal, do: process_line(goal, [first, second | rest], :*)
    defp process_line(goal, [first, second | rest]) when first * second > goal, do: process_line(goal, [first, second | rest], :+)

    defp process_line(goal, [first, second | rest]) do
      result = process_line(goal, [first, second | rest], :*)

      case result do
        0 -> process_line(goal, [first, second | rest], :+)
        _ -> result
      end
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      input
      |> Enum.filter(&(&1 != ""))
      |> Enum.reduce(0, fn list, acc ->
        [goal | numbers] = list
        |> String.split(~r/:| /, trim: true)
        |> Enum.map(&String.to_integer/1)

        acc + process_line(goal, numbers)
      end)
    end


    defp process_line(goal, [first, second | rest], :concat) do
      result = String.to_integer("#{first}#{second}")
      cond do
        result > goal -> 0
        true -> process_line(goal, [result | rest])
      end
    end

    defp process_line(goal, [first, second | rest], :multiply) do
      result = first * second
      cond do
        result > goal -> 0
        true -> process_line(goal, [result | rest])
      end
    end

    defp process_line(goal, [first, second | rest], :add) do
      result = first + second
      cond do
        result > goal -> 0
        true -> process_line(goal, [result | rest])
      end
    end

    defp process_line(goal, [number]) when goal == number, do: goal
    defp process_line(_goal, [_number]), do: 0
    defp process_line(goal, [first, second | rest]) do
      result = process_line(goal, [first, second | rest], :concat)
      result = if result > 0, do: result, else: process_line(goal, [first, second | rest], :multiply)
      if result > 0, do: result, else: process_line(goal, [first, second | rest], :add)
    end
  end
end
