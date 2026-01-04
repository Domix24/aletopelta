defmodule Aletopelta.Year2017.Day18 do
  @moduledoc """
  Day 18 of Year 2017
  """
  alias Aletopelta.Year2017.Machine

  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: Machine.input()
    @type output() :: integer()

    @spec parse_input(input()) :: Machine.instructions()
    def parse_input(input) do
      Machine.parse(input)
    end

    @spec execute_instruction(
            Machine.instruction(),
            Machine.registers(),
            Machine.options(),
            (Machine.instruction(), Machine.registers(), Machine.options() -> Machine.execute())
          ) :: Machine.execute()
    def execute_instruction(["snd", register], registers, _, _) do
      frequency = Map.get(registers, register, 0)
      {:frequency, frequency}
    end

    def execute_instruction(instruction, registers, options, callback),
      do: callback.(instruction, registers, options)

    @spec process_result(
            Machine.execute(),
            Machine.pointer(),
            Machine.registers(),
            Machine.options(),
            (any(), Machine.pointer(), Machine.registers(), Machine.options() ->
               Machine.process())
          ) :: Machine.process()
    def process_result({:frequency, frequency}, pointer, registers, options, _) do
      new_options = Map.update!(options, :send, &[frequency | &1])

      {pointer + 1, registers, new_options}
    end

    def process_result(result, pointer, registers, options, callback),
      do: callback.(result, pointer, registers, options)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Machine.new(
        options: %{
          send: [],
          process: fn result, pointer, registers, options ->
            Common.process_result(result, pointer, registers, options, &process_result/4)
          end,
          execute: fn instruction, registers, options ->
            Common.execute_instruction(instruction, registers, options, &execute_instruction/3)
          end
        }
      )
      |> Machine.start()
      |> elem(3)
      |> Map.fetch!(:output)
    end

    defp execute_instruction(["rcv", register], registers, %{send: [last | _]}) do
      value = Map.get(registers, register, 0)

      if value === 0 do
        :nothing
      else
        {:scream, last}
      end
    end

    defp process_result({:scream, frequency}, pointer, registers, options) do
      {:pause, pointer, registers, Map.put(options, :output, frequency)}
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
      |> Map.new(&prepare_machine(input, &1))
      |> loop_machines(0, 0)
    end

    defp prepare_machine(instructions, value) do
      registers = Map.new([{"p", value}])

      {value,
       Machine.new(instructions,
         registers: registers,
         options: %{
           send: [],
           receive: [],
           execute: fn instruction, registers, options ->
             Common.execute_instruction(instruction, registers, options, &execute_instruction/3)
           end,
           process: fn result, pointer, registers, options ->
             Common.process_result(result, pointer, registers, options, &process_result/4)
           end
         }
       )}
    end

    defp execute_instruction(["rcv", register], registers, %{receive: [frequency | others]}),
      do: {:receive, Map.put(registers, register, frequency), others}

    defp execute_instruction(["rcv", _], _, %{receive: [], send: xsend}),
      do: {:receive, Enum.reverse(xsend)}

    defp process_result({:receive, registers, xreceive}, pointer, _, options) do
      new_options = Map.update!(options, :receive, fn _ -> xreceive end)

      {pointer + 1, registers, new_options}
    end

    defp process_result({:receive, xsend}, pointer, registers, options) do
      new_options = Map.update!(options, :send, fn _ -> xsend end)

      {:pause, pointer, registers, new_options}
    end

    defp loop_machines(machines, index, sum),
      do:
        index
        |> process_machine(machines)
        |> continue_process(rem(index + 1, 2), sum)

    defp sum_send(machines, sum),
      do:
        machines
        |> Map.fetch!(1)
        |> elem(3)
        |> Map.fetch!(:send)
        |> length()
        |> Kernel.+(sum)

    defp continue_process({machines, {_, _, _, %{send: []}}}, index, sum),
      do: continue_process({machines, nil}, index, sum)

    defp continue_process({machines, _}, 0 = index, sum) do
      new_sum = sum_send(machines, sum)

      loop_machines(machines, index, new_sum)
    end

    defp continue_process({machines, nil}, 1, sum), do: sum_send(machines, sum)

    defp continue_process({machines, _}, index, sum), do: loop_machines(machines, index, sum)

    defp process_machine(index, machines) do
      other_index = rem(index + 1, 2)

      {other_instructions, other_pointer, other_registers, %{send: other_send} = other_options} =
        Map.fetch!(machines, other_index)

      {instructions, pointer, registers, options} = Map.fetch!(machines, index)

      new_options =
        options
        |> Map.update!(:send, fn _ -> [] end)
        |> Map.update!(:receive, fn _ -> other_send end)

      machine = Machine.start({instructions, pointer, registers, new_options})

      new_otheroptions = Map.update!(other_options, :send, fn _ -> [] end)

      new_machines =
        machines
        |> Map.put(index, machine)
        |> Map.put(
          other_index,
          {other_instructions, other_pointer, other_registers, new_otheroptions}
        )

      {new_machines, machine}
    end
  end
end
