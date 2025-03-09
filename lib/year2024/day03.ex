defmodule Aletopelta.Year2024.Day03 do
  @moduledoc """
  Day 3 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """
    def parse_input(input) do
      pattern = ~r/(mul\(([0-9]{1,3}),([0-9]{1,3})\))|(d(.{1}|.{4})\(\))/i

      Enum.flat_map(input, &Regex.scan(pattern, &1))
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.filter(fn [message | _] -> String.slice(message, 0, 3) == "mul" end)
      |> Enum.map(&parse_text/1)
      |> Enum.sum()
    end

    defp parse_text([_, _, first, second]) do
      String.to_integer(first) * String.to_integer(second)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    def execute(input) do
      input
      |> Common.parse_input()
      |> calculate(:active)
    end

    def calculate([], _active), do: 0

    def calculate([message | rest], active) do
      case String.slice(Enum.at(message, 0), 0, 3) do
        "don" ->
          calculate(rest, :notactive)

        "do(" ->
          calculate(rest, :active)

        "mul" ->
          case active do
            :active ->
              String.to_integer(Enum.at(message, 2)) * String.to_integer(Enum.at(message, 3)) +
                calculate(rest, active)

            :notactive ->
              calculate(rest, active)
          end

        _ ->
          calculate(rest, active)
      end
    end
  end
end
