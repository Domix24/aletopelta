defmodule Aletopelta.Year2018.Day21 do
  @moduledoc """
  Day 21 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
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
    defp parsed_opcode("bani"), do: :bani
    defp parsed_opcode("eqri"), do: :eqri
    defp parsed_opcode("bori"), do: :bori
    defp parsed_opcode("gtir"), do: :gtir

    @spec do_part(%{integer() => {atom(), [integer()]}}, integer()) ::
            {integer(), integer(), integer(), integer(), integer(), integer()}
    def do_part(parsed, register0) do
      {:ip, [register]} = Map.get(parsed, -1)
      registers = {0, 0, 0, 0, 0, 0}
      pointer = read_register(registers, register)

      parsed
      |> Map.fetch!(pointer)
      |> run_program(registers, register, parsed, pointer, register0, {Map.new(), nil})
    end

    defp run_program(nil, registers, _, _, _, _, _), do: registers

    defp run_program(
           {opcode, inputs},
           registers,
           register,
           map,
           pointer,
           register0,
           {visited, last}
         ) do
      {new_registers, new_visited, new_last} =
        registers
        |> write_register(register, pointer)
        |> optimize({register0, register, pointer}, opcode, inputs, visited, last)

      new_pointer = read_register(new_registers, register) + 1

      map
      |> Map.get(new_pointer)
      |> run_program(
        new_registers,
        register,
        map,
        new_pointer,
        register0,
        {new_visited, new_last}
      )
    end

    defp optimize(registers, {_, _, 17}, _, _, visited, last) do
      register_2 = read_register(registers, 2)
      register_1 = div(register_2, 256)

      registers
      |> write_register(1, register_1)
      |> append_state(visited, last)
    end

    defp optimize(registers, {0, _, 28}, opcode, [a, b, _] = inputs, visited, last),
      do:
        registers
        |> write_register(b, read_register(registers, a))
        |> apply_opcode(opcode, inputs)
        |> append_state(visited, last)

    defp optimize(registers, {1, _, 28}, opcode, [a, b, _] = inputs, visited, last) do
      register_a = read_register(registers, a)

      {new_registers, new_visited, new_last} =
        if Map.has_key?(visited, register_a) do
          new_registers =
            registers
            |> write_register(4, last)
            |> write_register(b, register_a)

          {new_registers, visited, last}
        else
          {registers, Map.put(visited, register_a, 1), register_a}
        end

      new_registers
      |> apply_opcode(opcode, inputs)
      |> append_state(new_visited, new_last)
    end

    defp optimize(registers, _, opcode, inputs, visited, last),
      do:
        registers
        |> apply_opcode(opcode, inputs)
        |> append_state(visited, last)

    defp append_state(registers, visited, last), do: {registers, visited, last}

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

    defp apply_opcode(registers, :eqri, [a, b, c]) do
      if read_register(registers, a) === b do
        write_register(registers, c, 1)
      else
        write_register(registers, c, 0)
      end
    end

    defp apply_opcode(registers, :eqrr, [a, b, c]) do
      if read_register(registers, a) === read_register(registers, b) do
        write_register(registers, c, 1)
      else
        write_register(registers, c, 0)
      end
    end

    defp apply_opcode(registers, :gtir, [a, b, c]) do
      if a > read_register(registers, b) do
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

    defp apply_opcode(registers, :bani, [a, b, c]) do
      input_1 = read_register(registers, a)

      write_register(registers, c, Bitwise.band(input_1, b))
    end

    defp apply_opcode(registers, :bori, [a, b, c]) do
      input_1 = read_register(registers, a)

      write_register(registers, c, Bitwise.bor(input_1, b))
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part(0)
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_part(1)
      |> elem(4)
    end
  end
end
