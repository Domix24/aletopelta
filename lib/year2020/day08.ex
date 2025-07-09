defmodule Aletopelta.Year2020.Day08 do
  @moduledoc """
  Day 8 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type command() :: :acc | :jmp | :nop
    @type program() :: %{integer() => {command(), integer()}}

    @spec parse_input(input()) :: program()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index ->
        [freecommand, freenumber] = String.split(line, " ")

        number =
          ~r/-?\d+/
          |> Regex.run(freenumber)
          |> Enum.at(0)
          |> String.to_integer()

        command = parse_command(freecommand)

        {index, {command, number}}
      end)
      |> Map.new()
    end

    defp parse_command("acc"), do: :acc
    defp parse_command("nop"), do: :nop
    defp parse_command("jmp"), do: :jmp

    defp before_traverse(program, index, visited, register) do
      cond do
        !Map.has_key?(program, index) ->
          {:success, register}

        Map.has_key?(visited, index) ->
          {:double, register}

        true ->
          new_visited = Map.put(visited, index, 1)
          traverse(program, index, new_visited, register)
      end
    end

    defp traverse(program, index, visited, register) do
      program
      |> Map.fetch!(index)
      |> execute_action(register, index)
      |> to_traverse(program, visited)
    end

    defp to_traverse({register, index}, program, visited) do
      before_traverse(program, index + 1, visited, register)
    end

    defp execute_action({:acc, value}, register, index), do: {register + value, index}
    defp execute_action({:nop, _}, register, index), do: {register, index}
    defp execute_action({:jmp, value}, register, index), do: {register, index + value - 1}

    @spec traverse(program()) :: {:double, integer()} | {:success, integer()}
    def traverse(program) do
      traverse(program, 0, Map.new(), 0)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> elem(1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> try_traverse()
    end

    defp try_traverse(program) do
      program
      |> Enum.reject(&(elem(elem(&1, 1), 0) == :acc))
      |> Enum.reduce_while(0, fn {index, {old, value}}, _ ->
        program
        |> Map.put(index, {replace(old), value})
        |> Common.traverse()
        |> handle_result()
      end)
    end

    defp handle_result({:success, value}), do: {:halt, value}
    defp handle_result(_), do: {:cont, 0}

    defp replace(:jmp), do: :nop
    defp replace(:nop), do: :jmp
  end
end
