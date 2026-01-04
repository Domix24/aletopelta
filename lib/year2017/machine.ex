defmodule Aletopelta.Year2017.Machine do
  @moduledoc """
  Machine
  """

  @type input() :: list(binary())
  @type instructions() :: %{pointer() => instruction()}
  @type instruction() :: list(binary())
  @type registers() :: %{binary() => integer()}
  @type pointer() :: integer()
  @type machine() :: {instructions(), pointer(), registers(), options()}
  @type options() :: map()

  @type process() :: {pointer(), registers(), options()}
  @type execute() :: any()

  @spec parse(input()) :: instructions()
  def parse(input),
    do:
      input
      |> Enum.with_index(&{&2, String.split(&1)})
      |> Map.new()

  @spec start(machine()) :: machine()
  def start({instructions, pointer, registers, options}),
    do: process(instructions, pointer, registers, options)

  @spec new(instructions, keyword()) :: machine()
  def new(instructions, options \\ []),
    do:
      {instructions, Keyword.get(options, :pointer, 0),
       Keyword.get(options, :registers, Map.new()), Keyword.get(options, :options, Map.new())}

  defp process(instructions, pointer, registers, options),
    do:
      instructions
      |> Map.get(pointer)
      |> prepare()
      |> operate_instruction(instructions, pointer, registers, options)

  defp operate_instruction(instruction, instructions, pointer, registers, options),
    do:
      instruction
      |> execute(registers, options)
      |> process_result(
        instructions,
        pointer,
        registers,
        operate(instruction, options, Map.get(options, :operate))
      )

  defp operate(_, options, nil), do: options
  defp operate(instruction, options, callback), do: callback.(instruction, options)

  defp process_result(:nothing, instructions, pointer, registers, options),
    do: process(instructions, pointer + 1, registers, options)

  defp process_result({:increase, offset}, instructions, pointer, registers, options),
    do: process(instructions, pointer + offset, registers, options)

  defp process_result({:registers, registers}, instructions, pointer, _, options),
    do: process(instructions, pointer + 1, registers, options)

  defp process_result(nil, instructions, pointer, registers, options),
    do: {instructions, pointer, registers, options}

  defp process_result(result, instructions, pointer, registers, %{process: func} = options),
    do:
      result
      |> func.(pointer, registers, options)
      |> forward(instructions)

  defp forward({pointer, registers, options}, instructions),
    do: process(instructions, pointer, registers, options)

  defp forward({:pause, pointer, registers, options}, instructions),
    do: {instructions, pointer, registers, options}

  defp prepare([_, _] = instruction), do: instruction

  defp prepare([name, a, b]) do
    {prepared_a, converted_a} = prepare_type(a)
    {prepared_b, converted_b} = prepare_type(b)

    [name, prepared_a, converted_a, prepared_b, converted_b]
  end

  defp prepare(nil), do: nil

  defp prepare_type(value) do
    case Regex.scan(~r"\d+", value) do
      [_] -> {:number, String.to_integer(value)}
      _ -> {:register, value}
    end
  end

  defp execute(nil, _, _), do: nil

  defp execute(["set", :register, registera, :number, valueb], registers, _),
    do: {:registers, Map.put(registers, registera, valueb)}

  defp execute(["mul", :register, registera, :number, valueb], registers, _),
    do: {:registers, Map.update(registers, registera, 0, &(&1 * valueb))}

  defp execute(["add", :register, registera, :number, valueb], registers, _),
    do: {:registers, Map.update(registers, registera, valueb, &(&1 + valueb))}

  defp execute(["mod", :register, registera, :number, valueb], registers, _),
    do: {:registers, Map.update(registers, registera, valueb, &rem(&1, valueb))}

  defp execute(["sub", :register, registera, :number, valueb], registers, _),
    do: {:registers, Map.update(registers, registera, -valueb, &(&1 - valueb))}

  defp execute(["jgz", :register, registera, :number, valueb], registers, options) do
    valuea = Map.get(registers, registera, 0)
    execute(["jgz", :number, valuea, :number, valueb], registers, options)
  end

  defp execute(["jgz", :number, valuea, :number, valueb], _, _) do
    if valuea > 0 do
      {:increase, valueb}
    else
      :nothing
    end
  end

  defp execute(["jnz", :register, registera, :number, valueb], registers, options) do
    valuea = Map.get(registers, registera, 0)
    execute(["jnz", :number, valuea, :number, valueb], registers, options)
  end

  defp execute(["jnz", :number, valuea, :number, valueb], _, _) do
    if valuea === 0 do
      :nothing
    else
      {:increase, valueb}
    end
  end

  defp execute([name, :register, registera, :register, registerb], registers, options) do
    valueb = Map.get(registers, registerb, 0)
    execute([name, :register, registera, :number, valueb], registers, options)
  end

  defp execute(instruction, registers, %{execute: func} = options),
    do: func.(instruction, registers, options)
end
