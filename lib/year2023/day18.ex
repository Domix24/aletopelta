defmodule Aletopelta.Year2023.Day18 do
  @moduledoc """
  Day 18 of Year 2023
  """
  defmodule Digger do
    @moduledoc """
    Digger
    """
    defstruct [:direction, :amount, :color]
  end

  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """
    def parse_input(input) do
      Enum.map(input, fn line ->
        [direction, amount, color] = String.split(line)
        direction = String.to_atom(direction)
        amount = String.to_integer(amount)
        [_, color] = Regex.run(~r/([a-z0-9]+)/, color)
        %Digger{direction: direction, amount: amount, color: color}
      end)
    end

    def calculate(list) do
      {_, _, _, value} =
        Enum.reduce(list, {0, 0, 0, 0}, fn digger, {row, column, index, area} ->
          {new_row, new_column} =
            case digger.direction do
              :R -> {row, column + digger.amount}
              :D -> {row + digger.amount, column}
              :L -> {row, column - digger.amount}
              :U -> {row - digger.amount, column}
            end

          area = area + column * new_row - row * new_column + digger.amount
          {new_row, new_column, index + 1, area}
        end)

      div(value, 2) + 1
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.calculate()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    def execute(input) do
      Common.parse_input(input)
      |> parse
      |> Common.calculate()
    end

    defp parse(input) do
      Enum.map(input, fn digger ->
        [_, amount, direction] = Regex.run(~r/([a-z0-9]+)([0-3])/, digger.color)

        {amount, _} = Integer.parse(amount, 16)

        direction =
          case direction do
            "0" -> :R
            "1" -> :D
            "2" -> :L
            "3" -> :U
          end

        %{digger | direction: direction, amount: amount}
      end)
    end
  end
end
