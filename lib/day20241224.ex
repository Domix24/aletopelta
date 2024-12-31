defmodule Aletopelta.Day20241224 do
  defmodule Common do
  end

  defmodule Part1 do
    @pattern_wire ~r/^(\D\d+).*(\d)$/
    @pattern_gate ~r/^([a-z0-9]{3}).*\s(XOR|OR|AND)\s.*([a-z0-9]{3}).*([a-z0-9]{3})$/

    def execute(input \\ nil) do
      {wires, gates} = parse_input(input)

      gates
      |> process_gates(wires)
      |> get_zwire
    end

    defp get_zwire(wires) do
      Enum.filter(wires, fn
        {"z" <> _, _} -> true
        _ -> false
      end)
      |> Enum.sum_by(fn {"z" <> rest, number} -> Bitwise.bsl(number, String.to_integer(rest)) end)
    end

    defp process_gates([], wires), do: wires
    defp process_gates(gates, wires) do
      {resolved_ops, remaining_ops} = Enum.split_with(gates, fn {_, var1, var2, _} ->
        Map.has_key?(wires, var1) and Map.has_key?(wires, var2)
      end)

      wires = Enum.reduce(resolved_ops, wires, &process_command/2)
      process_gates(remaining_ops, wires)
    end

    defp process_command({:AND, operand1, operand2, result}, wires) do
      Map.put(wires, result, Bitwise.band(Map.get(wires, operand1), Map.get(wires, operand2)))
    end
    defp process_command({:OR, operand1, operand2, result}, wires) do
      Map.put(wires, result, Bitwise.bor(Map.get(wires, operand1), Map.get(wires, operand2)))
    end
    defp process_command({:XOR, operand1, operand2, result}, wires) do
      Map.put(wires, result, Bitwise.bxor(Map.get(wires, operand1), Map.get(wires, operand2)))
    end

    defp parse_input(input) do
      [wires, _, gates | _] = split_input(input)

      wires = Enum.map(wires, &parse_wire/1) |> Map.new
      gates = Enum.map(gates, &parse_gate/1)

      {wires, gates}
    end

    defp split_input(input), do: split_input(input, [], [])
    defp split_input([], complete, []), do: Enum.reverse(complete)
    defp split_input([], complete, current), do: Enum.reverse([Enum.reverse(current) | complete])
    defp split_input(["" | others], complete, current), do: split_input(others, ["", Enum.reverse(current) | complete], [])
    defp split_input([first | others], complete, current), do: split_input(others, complete, [first | current])

    defp parse_wire(unparsed) do
      [_, name, digit] = Regex.run(@pattern_wire, unparsed)
      {name, String.to_integer(digit)}
    end

    defp parse_gate(unparsed) do
      [_, operand1, command, operand2, result] = Regex.run(@pattern_gate, unparsed)

      {String.to_atom(command), operand1, operand2, result}
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
