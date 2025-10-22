defmodule Aletopelta.Year2018.Day19 do
  @moduledoc """
  Day 19 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: %{integer() => {atom(), [integer()]}}
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index ->
        [opcode | args] = String.split(line, " ")

        parsed_opcode = parsed_opcode(opcode)
        parsed_args = Enum.map(args, &String.to_integer/1)

        {index - 1, {parsed_opcode, parsed_args}}
      end)
      |> Map.new()
    end

    defp parsed_opcode("#ip"), do: :ip
    defp parsed_opcode("addi"), do: :addi
    defp parsed_opcode("seti"), do: :seti
    defp parsed_opcode("mulr"), do: :mulr
    defp parsed_opcode("eqrr"), do: :eqrr
    defp parsed_opcode("addr"), do: :addr
    defp parsed_opcode("gtrr"), do: :gtrr
    defp parsed_opcode("setr"), do: :setr
    defp parsed_opcode("muli"), do: :muli

    @spec do_part(%{integer() => {atom(), [integer()]}}, integer()) :: integer()
    def do_part(parsed, register0) do
      {:ip, [register]} = Map.get(parsed, -1)
      registers = {register0, 0, 0, 0, 0, 0}
      pointer = read_register(registers, register)

      parsed
      |> Map.fetch!(pointer)
      |> run_program(registers, register, parsed, pointer, register0)
    end

    defp sum_divisor(number),
      do:
        Enum.sum_by(1..number, fn divisor ->
          case rem(number, divisor) do
            0 -> divisor
            _ -> 0
          end
        end)

    defp run_program(_, {_, _, _, _, _, number}, _, _, _, 0) when number > 900,
      do: sum_divisor(number)

    defp run_program(_, {_, _, _, _, _, number}, _, _, _, 1) when number > 9000,
      do: sum_divisor(number)

    defp run_program({opcode, inputs}, registers, register, map, pointer, register0) do
      new_registers =
        registers
        |> write_register(register, pointer)
        |> apply_opcode(opcode, inputs)

      new_pointer = read_register(new_registers, register) + 1

      map
      |> Map.get(new_pointer)
      |> run_program(new_registers, register, map, new_pointer, register0)
    end

    defp write_register({_, b, c, d, e, f}, 0, a), do: {a, b, c, d, e, f}
    defp write_register({a, _, c, d, e, f}, 1, b), do: {a, b, c, d, e, f}
    defp write_register({a, b, _, d, e, f}, 2, c), do: {a, b, c, d, e, f}
    defp write_register({a, b, c, _, e, f}, 3, d), do: {a, b, c, d, e, f}
    defp write_register({a, b, c, d, _, f}, 4, e), do: {a, b, c, d, e, f}
    defp write_register({a, b, c, d, e, _}, 5, f), do: {a, b, c, d, e, f}

    defp read_register(registers, index), do: elem(registers, index)

    defp apply_opcode(registers, :addi, [a, b, c]),
      do: write_register(registers, c, read_register(registers, a) + b)

    defp apply_opcode(registers, :addr, [a, b, c]),
      do: write_register(registers, c, read_register(registers, a) + read_register(registers, b))

    defp apply_opcode(registers, :seti, [a, _, c]), do: write_register(registers, c, a)

    defp apply_opcode(registers, :setr, [a, _, c]),
      do: write_register(registers, c, read_register(registers, a))

    defp apply_opcode(registers, :muli, [a, b, c]),
      do: write_register(registers, c, read_register(registers, a) * b)

    defp apply_opcode(registers, :mulr, [a, b, c]),
      do: write_register(registers, c, read_register(registers, a) * read_register(registers, b))

    defp apply_opcode(registers, :eqrr, [a, b, c]) do
      if read_register(registers, a) === read_register(registers, b) do
        write_register(registers, c, 1)
      else
        write_register(registers, c, 0)
      end
    end

    defp apply_opcode(registers, :gtrr, [a, b, c]) do
      if read_register(registers, a) > read_register(registers, b) do
        write_register(registers, c, 1)
      else
        write_register(registers, c, 0)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part(1)
    end
  end
end
