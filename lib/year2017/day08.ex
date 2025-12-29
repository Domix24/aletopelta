defmodule Aletopelta.Year2017.Day08 do
  @moduledoc """
  Day 8 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.split/1)
    end

    defp reduce(
           [
             register,
             operator,
             number,
             _,
             condition_register,
             condition_operator,
             condition_number
           ],
           {old_registers, old_highest} = acc
         ) do
      case check_condition(
             condition_register,
             condition_operator,
             String.to_integer(condition_number),
             old_registers
           ) do
        true ->
          registers = apply_operator(register, operator, String.to_integer(number), old_registers)

          highest =
            registers
            |> Map.values()
            |> Enum.max()
            |> max(old_highest)

          {registers, highest}

        false ->
          acc
      end
    end

    @spec reduce(list(binary())) :: {%{binary() => integer()}, integer()}
    def reduce(input), do: Enum.reduce(input, {Map.new(), 0}, &reduce/2)

    defp check_condition(register, "==", number, registers),
      do: Map.get(registers, register, 0) == number

    defp check_condition(register, ">", number, registers),
      do: Map.get(registers, register, 0) > number

    defp check_condition(register, ">=", number, registers),
      do: Map.get(registers, register, 0) >= number

    defp check_condition(register, "<", number, registers),
      do: Map.get(registers, register, 0) < number

    defp check_condition(register, "<=", number, registers),
      do: Map.get(registers, register, 0) <= number

    defp check_condition(register, "!=", number, registers),
      do: Map.get(registers, register, 0) != number

    defp apply_operator(register, "dec", number, registers),
      do: Map.update(registers, register, -number, &(&1 - number))

    defp apply_operator(register, "inc", number, registers),
      do: Map.update(registers, register, number, &(&1 + number))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.reduce()
      |> elem(0)
      |> Map.values()
      |> Enum.max()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.reduce()
      |> elem(1)
    end
  end
end
