defmodule Aletopelta.Year2017.Day18 do
  @moduledoc """
  Day 18 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: %{integer() => list(binary())}
    def parse_input(input) do
      input
      |> Enum.with_index(&{&2, String.split(&1)})
      |> Map.new()
    end

    @spec process(
            %{integer() => list(binary())},
            integer(),
            %{binary() => integer()},
            {list(integer()), list(integer())},
            :part1 | :part2
          ) :: integer() | {%{binary() => integer()}, integer(), list(integer())}
    def process(instructions, pointer, registers, frequencies, part) do
      instructions
      |> Map.get(pointer)
      |> prepare_instruction()
      |> execute_instruction(registers, frequencies, part)
      |> process_result(instructions, pointer, registers, frequencies, part)
    end

    defp process_result(:nothing, instructions, pointer, registers, frequencies, part),
      do: process(instructions, pointer + 1, registers, frequencies, part)

    defp process_result({:sound, frequency}, _, _, _, _, _), do: frequency

    defp process_result({:increase, offset}, instructions, pointer, registers, frequencies, part),
      do: process(instructions, pointer + offset, registers, frequencies, part)

    defp process_result(
           {:frequency, frequency},
           instructions,
           pointer,
           registers,
           {xsend, xreceive},
           part
         ),
         do: process(instructions, pointer + 1, registers, {[frequency | xsend], xreceive}, part)

    defp process_result({:registers, new_registers}, instructions, pointer, _, frequencies, part),
      do: process(instructions, pointer + 1, new_registers, frequencies, part)

    defp process_result(
           {:receive, new_registers, new_receive},
           instructions,
           pointer,
           _,
           {xsend, _} = _,
           part
         ), do: process(instructions, pointer + 1, new_registers, {xsend, new_receive}, part)

    defp process_result(:wait, _, pointer, registers, {xsend, _}, _),
      do: {registers, pointer, Enum.reverse(xsend)}

    defp prepare_instruction([_, _] = instruction), do: instruction

    defp prepare_instruction([name, a, b]) do
      {prepared_a, converted_a} = prepare_type(a)
      {prepared_b, converted_b} = prepare_type(b)

      [name, prepared_a, converted_a, prepared_b, converted_b]
    end

    defp prepare_type(value) do
      case Regex.scan(~r"\d+", value) do
        [_] -> {:number, String.to_integer(value)}
        _ -> {:register, value}
      end
    end

    defp execute_instruction(["set", :register, registera, :number, valueb], registers, _, _),
      do: {:registers, Map.put(registers, registera, valueb)}

    defp execute_instruction(["mul", :register, registera, :number, valueb], registers, _, _),
      do: {:registers, Map.update(registers, registera, 0, &(&1 * valueb))}

    defp execute_instruction(["add", :register, registera, :number, valueb], registers, _, _),
      do: {:registers, Map.update(registers, registera, valueb, &(&1 + valueb))}

    defp execute_instruction(["mod", :register, registera, :number, valueb], registers, _, _),
      do: {:registers, Map.update(registers, registera, valueb, &rem(&1, valueb))}

    defp execute_instruction(["jgz", :register, registera, :number, valueb], registers, _, _) do
      valuea = Map.get(registers, registera, 0)
      execute_instruction(["jgz", :number, valuea, :number, valueb], registers, nil, nil)
    end

    defp execute_instruction(["jgz", :number, valuea, :number, valueb], _, _, _) do
      if valuea > 0 do
        {:increase, valueb}
      else
        :nothing
      end
    end

    defp execute_instruction(["snd", register], registers, _, _) do
      value = Map.get(registers, register, 0)
      {:frequency, value}
    end

    defp execute_instruction(["rcv", _], _, {_, []}, :part2), do: :wait

    defp execute_instruction(["rcv", register], registers, {_, [last | frequencies]}, :part2),
      do: {:receive, Map.put(registers, register, last), frequencies}

    defp execute_instruction(["rcv", register], registers, {[last | _], _}, :part1) do
      value = Map.get(registers, register, 0)

      if value === 0 do
        :nothing
      else
        {:sound, last}
      end
    end

    defp execute_instruction([name, :register, registera, :register, registerb], registers, _, _) do
      valueb = Map.get(registers, registerb, 0)
      execute_instruction([name, :register, registera, :number, valueb], registers, nil, nil)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.process(0, Map.new(), {[], []}, :part1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(input) do
      0..1
      |> Map.new(&prepare_machine/1)
      |> loop_machines(0, input, 0)
    end

    defp prepare_machine(value) do
      registers = Map.new([{"p", value}])
      pointer = 0
      xreceive = []

      {value, {registers, pointer, xreceive}}
    end

    defp loop_machines(machines, index, instructions, sum) do
      index
      |> process_machine(machines, instructions)
      |> continue_process(rem(index + 1, 2), instructions, sum)
    end

    defp sum_send(machines, sum) do
      machines
      |> Map.fetch!(1)
      |> elem(2)
      |> length()
      |> Kernel.+(sum)
    end

    defp continue_process({machines, {_, _, []}}, index, instructions, sum),
      do: continue_process({machines, nil}, index, instructions, sum)

    defp continue_process({machines, _}, 0 = index, instructions, sum) do
      new_sum = sum_send(machines, sum)

      loop_machines(machines, index, instructions, new_sum)
    end

    defp continue_process({machines, nil}, 1, _, sum), do: sum_send(machines, sum)

    defp continue_process({machines, _}, index, instructions, sum),
      do: loop_machines(machines, index, instructions, sum)

    defp process_machine(index, machines, instructions) do
      other_index = rem(index + 1, 2)

      {other_registers, other_pointer, other_send} = Map.fetch!(machines, other_index)
      {registers, pointer, _} = Map.fetch!(machines, index)

      machine = Common.process(instructions, pointer, registers, {[], other_send}, :part2)

      new_machines =
        machines
        |> Map.put(index, machine)
        |> Map.put(other_index, {other_registers, other_pointer, []})

      {new_machines, machine}
    end
  end
end
