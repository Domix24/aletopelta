defmodule Aletopelta.Year2023.Day09 do
  @moduledoc """
  Day 9 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """
    def parse_input(input) do
      Enum.map(input, fn line ->
        Regex.scan(~r/-?\d+/, line)
        |> Enum.map(fn [number] -> String.to_integer(number) end)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&find_pattern/1)
      |> Enum.map(&Enum.sum/1)
      |> Enum.sum()
    end

    defp find_pattern(line) do
      do_pattern(line)
      |> dispatch_pattern
    end

    defp do_pattern([number1, number2]) do
      {number2, [number2 - number1]}
    end

    defp do_pattern([number1, number2 | others]) do
      {lastnum, list} = do_pattern([number2 | others])
      {lastnum, [number2 - number1 | list]}
    end

    defp dispatch_pattern({last_number, differences}) do
      if Enum.all?(differences, &(&1 == 0)) do
        [last_number]
      else
        [last_number | find_pattern(differences)]
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&find_pattern/1)
      |> Enum.map(&substract/1)
      |> Enum.sum()
    end

    defp find_pattern(line) do
      do_pattern(line)
      |> dispatch_pattern
    end

    defp do_pattern([number1, number2]) do
      {0, [number2 - number1]}
    end

    defp do_pattern([number1, number2 | others]) do
      {_, list} = do_pattern([number2 | others])
      {number1, [number2 - number1 | list]}
    end

    defp dispatch_pattern({first_number, differences}) do
      if Enum.all?(differences, &(&1 == 0)) do
        [first_number]
      else
        [first_number | find_pattern(differences)]
      end
    end

    defp substract([number1]) do
      number1
    end

    defp substract([number1 | others]) do
      number1 - substract(others)
    end
  end
end
