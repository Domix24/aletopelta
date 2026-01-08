defmodule Aletopelta.Year2016.Day12 do
  @moduledoc """
  Day 12 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type instruction() :: list(atom() | integer())
    @type instructions() :: %{integer => instruction()}
    @type registers() :: %{atom() => integer()}

    @spec parse_input(input()) :: instructions()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index ->
        [sname | lrest] = String.split(line)

        [name] = ~w"#{sname}"a
        rest = parse_options(lrest)

        {index, [name | rest]}
      end)
      |> Map.new()
    end

    defp parse_options(options) do
      Enum.flat_map(options, fn part ->
        case Regex.run(~r"\d+", part) do
          nil -> ~w"#{part}"a
          [_] -> [String.to_integer(part)]
        end
      end)
    end

    @spec start_computer(instructions(), 0 | 1) :: {instructions(), integer(), registers()}
    def start_computer(instructions, register_c),
      do: execute_computer(instructions, 0, Map.new([{:c, register_c}]))

    defp execute_computer(instructions, pointer, registers) do
      instructions
      |> Map.get(pointer)
      |> execute_instruction(registers)
      |> process_result(instructions, pointer, registers)
    end

    defp execute_instruction([:cpy, number, register], _) when is_integer(number),
      do: {:set, register, number}

    defp execute_instruction([:cpy, register_x, register_y], registers),
      do: execute_instruction([:cpy, Map.get(registers, register_x, 0), register_y], registers)

    defp execute_instruction([:jnz, 0, _], _), do: :nothing

    defp execute_instruction([:jnz, number_x, number_y], _) when is_integer(number_x),
      do: {:move, number_y}

    defp execute_instruction([:jnz, register, number], registers),
      do: execute_instruction([:jnz, Map.get(registers, register, 0), number], registers)

    defp execute_instruction([:inc, register], registers),
      do: {:set, register, Map.get(registers, register, 0) + 1}

    defp execute_instruction([:dec, register], registers),
      do: {:set, register, Map.get(registers, register, 0) - 1}

    defp execute_instruction(nil, _), do: :quit

    defp process_result({:set, register, number}, instructions, pointer, registers) do
      new_pointer = pointer + 1
      new_registers = Map.put(registers, register, number)

      execute_computer(instructions, new_pointer, new_registers)
    end

    defp process_result(:quit, instructions, pointer, registers),
      do: {instructions, pointer, registers}

    defp process_result(:nothing, instructions, pointer, registers),
      do: execute_computer(instructions, pointer + 1, registers)

    defp process_result({:move, offset}, instructions, pointer, registers),
      do: execute_computer(instructions, pointer + offset, registers)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_computer(0)
      |> elem(2)
      |> Map.fetch!(:a)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_computer(1)
      |> elem(2)
      |> Map.fetch!(:a)
    end
  end
end
