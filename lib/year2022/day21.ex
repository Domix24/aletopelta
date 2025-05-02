defmodule Aletopelta.Year2022.Day21 do
  @moduledoc """
  Day 21 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """
    @spec parse_input(list(binary())) :: any()
    def parse_input(input) do
      input
      |> Enum.map(&String.split(&1, [":", " "], trim: true))
      |> Enum.reduce(%{}, fn
        [monkey, monkey_a, operator, monkey_b], acc ->
          value = %{
            monkey_a: monkey_a,
            monkey_b: monkey_b,
            operation: String.to_existing_atom(operator)
          }

          Map.put(acc, monkey, value)

        [monkey, number], acc ->
          value = %{number: String.to_integer(number)}
          Map.put(acc, monkey, value)
      end)
    end

    @spec traverse(map(), any()) :: {any(), map(), boolean()}
    def traverse(map, key) do
      current = Map.fetch!(map, key)
      new_map = Map.delete(map, key)

      case current do
        %{number: number} ->
          {number, new_map, key == "humn"}

        %{monkey_a: monkey_a, monkey_b: monkey_b, operation: operation} ->
          {monkey_avalue, monkey_amap, monkey_aunknown} = traverse(new_map, monkey_a)
          {monkey_bvalue, monkey_bmap, monkey_bunknown} = traverse(monkey_amap, monkey_b)

          number = execute_operation(operation, monkey_avalue, monkey_bvalue)
          {number, monkey_bmap, monkey_aunknown or monkey_bunknown}
      end
    end

    defp execute_operation(:+, number1, number2), do: number1 + number2
    defp execute_operation(:-, number1, number2), do: number1 - number2
    defp execute_operation(:*, number1, number2), do: number1 * number2
    defp execute_operation(:/, number1, number2), do: div(number1, number2)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> traverse()
    end

    defp traverse(map) do
      map
      |> Common.traverse("root")
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute([binary()]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> traverse()
    end

    defp traverse(map) do
      %{monkey_a: monkey_a, monkey_b: monkey_b} = Map.fetch!(map, "root")
      current_map = Map.delete(map, "root")

      {monkeya_number, monkeya_map, monkeya_unknown} = Common.traverse(current_map, monkey_a)
      {monkeyb_number, _, _} = Common.traverse(monkeya_map, monkey_b)

      {monkey, number} =
        if monkeya_unknown do
          {monkey_a, monkeyb_number}
        else
          {monkey_b, monkeya_number}
        end

      reverse(current_map, monkey, number)
    end

    defp reverse(_, "humn", number), do: number

    defp reverse(map, key, number) do
      %{monkey_a: monkey_a, monkey_b: monkey_b, operation: operation} = Map.fetch!(map, key)
      new_map = Map.delete(map, key)

      {monkey_anumber, _, monkey_aunknown} = Common.traverse(new_map, monkey_a)
      {monkey_bnumber, _, monkey_bunknown} = Common.traverse(new_map, monkey_b)

      {new_number, monkey} =
        cond do
          monkey_aunknown ->
            new_number = reverse_operation(operation, nil, monkey_bnumber, number)
            {new_number, monkey_a}

          monkey_bunknown ->
            new_number = reverse_operation(operation, monkey_anumber, nil, number)
            {new_number, monkey_b}
        end

      reverse(new_map, monkey, new_number)
    end

    defp reverse_operation(:/, nil, y, z), do: z * y
    defp reverse_operation(:/, x, nil, z), do: div(x, z)

    defp reverse_operation(:+, nil, y, z), do: z - y
    defp reverse_operation(:+, x, nil, z), do: z - x

    defp reverse_operation(:*, nil, y, z), do: div(z, y)
    defp reverse_operation(:*, x, nil, z), do: div(z, x)

    defp reverse_operation(:-, nil, y, z), do: z + y
    defp reverse_operation(:-, x, nil, z), do: x - z
  end
end
