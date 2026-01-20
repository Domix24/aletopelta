defmodule Aletopelta.Year2015.Day23 do
  @moduledoc """
  Day 23 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type argument() :: {:letter, atom()} | {:number, integer()}
    @type instructions() :: %{
            integer() => {atom(), argument()} | {atom(), argument(), argument()}
          }

    @spec parse_input(input()) :: instructions()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index ->
        case Regex.scan(~r"[a-w0-9-]+", line) do
          [[operator], [first], [second]] ->
            {index, {to_atom(operator), to_description(first), to_description(second)}}

          [[operator], [first]] ->
            {index, {to_atom(operator), to_description(first)}}
        end
      end)
      |> Map.new()
    end

    defp to_atom(string),
      do:
        [string]
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)

    defp to_description(string),
      do:
        ~r"[a-z]"
        |> Regex.scan(string)
        |> to_description(string)

    defp to_description([], string), do: {:number, String.to_integer(string)}
    defp to_description(_, string), do: {:letter, to_atom(string)}

    @spec start(instructions(), integer()) :: output()
    def start(instructions, register_a),
      do:
        instructions
        |> start(0, Map.new([{:a, register_a}]))
        |> Map.fetch!(:b)

    defp start(instructions, pointer, registers) do
      instructions
      |> Map.get(pointer)
      |> exit({instructions, pointer, registers})
    end

    defp exit(nil, {_, _, registers}), do: registers

    defp exit(instruction, {instructions, pointer, registers}) do
      instruction
      |> preexecute(registers)
      |> execute()
      |> process({instructions, pointer, registers})
    end

    defp preexecute({operator, {:letter, letter}, {:number, _} = argument}, registers)
         when operator in [:jio, :jie],
         do: {operator, {:number, Map.get(registers, letter, 0)}, argument}

    defp preexecute({_, {:number, _}} = instruction, _), do: instruction

    defp preexecute({operator, {:letter, letter} = argument}, registers)
         when operator in [:inc, :tpl, :hlf],
         do: {operator, argument, {:number, Map.get(registers, letter, 0)}}

    defp execute({:jio, {:number, 1}, {:number, number}}), do: {:jump, number}
    defp execute({:jio, _, _}), do: :nothing

    defp execute({:jie, {:number, check}, {:number, number}}) when rem(check, 2) < 1,
      do: {:jump, number}

    defp execute({:jie, _, _}), do: :nothing

    defp execute({:jmp, {:number, number}}), do: {:jump, number}

    defp execute({:inc, {:letter, letter}, {:number, number}}), do: {:set, letter, number + 1}
    defp execute({:tpl, {:letter, letter}, {:number, number}}), do: {:set, letter, number * 3}
    defp execute({:hlf, {:letter, letter}, {:number, number}}), do: {:set, letter, div(number, 2)}

    defp process(:nothing, {instructions, pointer, registers}),
      do: start(instructions, pointer + 1, registers)

    defp process({:jump, offset}, {instructions, pointer, registers}),
      do: start(instructions, pointer + offset, registers)

    defp process({:set, letter, number}, {instructions, pointer, registers}),
      do: start(instructions, pointer + 1, Map.put(registers, letter, number))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start(0)
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
      |> Common.start(1)
    end
  end
end
