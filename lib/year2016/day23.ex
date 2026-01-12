defmodule Aletopelta.Year2016.Day23 do
  @moduledoc """
  Day 23 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
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

    defp parse_options(options),
      do:
        Enum.flat_map(options, fn part ->
          case Regex.run(~r"\d+", part) do
            nil -> ~w"#{part}"a
            [_] -> [String.to_integer(part)]
          end
        end)

    @spec start_computer(instructions(), 7) :: {instructions(), integer(), registers()}
    def start_computer(instructions, register_a),
      do: execute_computer(instructions, 0, Map.new([{:a, register_a}]))

    defp execute_computer(instructions, pointer, registers),
      do:
        instructions
        |> Map.get(pointer)
        |> prepare_instruction()
        |> execute_instruction(registers)
        |> process_result(instructions, pointer, registers)

    defp prepare_instruction([instruction, argument]), do: [instruction, prepare(argument)]

    defp prepare_instruction([instruction, argument1, argument2]),
      do: [instruction, prepare(argument1), prepare(argument2)]

    defp prepare_instruction(nil), do: nil

    defp prepare(number) when is_integer(number), do: {:number, number}
    defp prepare(register), do: {:register, register}

    defp execute_instruction([:cpy, {:number, number}, {:register, register}], _),
      do: {:set, register, number}

    defp execute_instruction(
           [:cpy, {:register, register_x}, {:register, _} = argument2],
           registers
         ),
         do:
           execute_instruction(
             [:cpy, {:number, Map.get(registers, register_x, 0)}, argument2],
             registers
           )

    defp execute_instruction([:jnz, {:number, 0}, _], _), do: :nothing
    defp execute_instruction([:jnz, {:number, _}, {:number, number_y}], _), do: {:move, number_y}

    defp execute_instruction([:jnz, {:number, _}, {:register, register}], registers),
      do: {:move, Map.get(registers, register, 0)}

    defp execute_instruction([:jnz, {:register, register}, argument2], registers),
      do:
        execute_instruction(
          [:jnz, {:number, Map.get(registers, register, 0)}, argument2],
          registers
        )

    defp execute_instruction([:inc, {:register, register}], registers),
      do: {:set, register, Map.get(registers, register, 0) + 1}

    defp execute_instruction([:dec, {:register, register}], registers),
      do: {:set, register, Map.get(registers, register, 0) - 1}

    defp execute_instruction([:tgl, {:register, register}], registers),
      do: {:toggle, Map.fetch!(registers, register)}

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

    defp process_result({:toggle, offset}, instructions, pointer, registers),
      do:
        instructions
        |> safe_update(pointer + offset)
        |> execute_computer(pointer + 1, registers)

    defp safe_update(instructions, index),
      do:
        instructions
        |> Map.fetch(index)
        |> update(index, instructions)

    defp update(:error, _, instructions), do: instructions
    defp update({:ok, _}, index, instructions), do: Map.update!(instructions, index, &toggle/1)

    defp toggle([instruction, argument]), do: [toggle(instruction, 1), argument]

    defp toggle([instruction, argument1, argument2]),
      do: [toggle(instruction, 2), argument1, argument2]

    defp toggle(:inc, _), do: :dec
    defp toggle(:jnz, _), do: :cpy

    defp toggle(_, 1), do: :inc
    defp toggle(_, 2), do: :jnz
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_computer(7)
      |> elem(2)
      |> Map.fetch!(:a)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(instructions) do
      [_, number1, _] = Map.fetch!(instructions, 19)
      [_, number2, _] = Map.fetch!(instructions, 20)

      Enum.product(2..12) + number1 * number2
    end
  end
end
