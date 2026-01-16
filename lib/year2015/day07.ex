defmodule Aletopelta.Year2015.Day07 do
  @moduledoc """
  Day 7 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type kit() :: %{
            (atom() | {atom(), atom()}) =>
              list(
                {integer(), atom()}
                | {{atom(), nil}, atom()}
                | {{atom(), nil, nil}, atom()}
                | {{atom(), nil, integer()}, atom()}
                | {{atom(), integer(), nil}, atom()}
              )
          }
    @type memory() :: %{atom() => integer()}

    @spec parse_input(input()) :: kit()
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> parse()
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    end

    defp parse([source_wire, operator, number, "->", target_wire])
         when operator in ["RSHIFT", "LSHIFT"],
         do:
           format(
             {Enum.at(~w"#{String.downcase(operator)}"a, 0), convert(source_wire),
              convert(number), convert(target_wire)}
           )

    defp parse([source_wire1, operator, source_wire2, "->", target_wire])
         when operator in ["OR", "AND"],
         do:
           format(
             {Enum.at(~w"#{String.downcase(operator)}"a, 0), convert(source_wire1),
              convert(source_wire2), convert(target_wire)}
           )

    defp parse([source_wire, "->", target_wire]),
      do: format({:assign, convert(source_wire), convert(target_wire)})

    defp parse(["NOT", source_wire, "->", target_wire]),
      do: format({:not, convert(source_wire), convert(target_wire)})

    defp format({operator, {:wire, wire1}, {:wire, wire2}, {:wire, wire3}}),
      do: {{wire1, wire2}, {{operator, nil, nil}, wire3}}

    defp format({operator, {:wire, wire1}, {:number, wire2}, {:wire, wire3}}),
      do: {wire1, {{operator, nil, wire2}, wire3}}

    defp format({operator, {:number, wire1}, {:wire, wire2}, {:wire, wire3}}),
      do: {wire2, {{operator, wire1, nil}, wire3}}

    defp format({operator, {:wire, wire1}, {:wire, wire2}}), do: {wire1, {{operator, nil}, wire2}}

    defp format({operator, {:number, wire1}, {:wire, wire2}}), do: {operator, {wire1, wire2}}

    defp convert(string) do
      case Regex.scan(~r"\d+", string) do
        [] -> {:wire, Enum.at(~w"#{String.downcase(string)}"a, 0)}
        [_] -> {:number, String.to_integer(string)}
      end
    end

    @spec follow_kit(kit(), integer()) :: memory()
    def follow_kit(kit, memory_b),
      do:
        kit
        |> Enum.split_with(&(elem(&1, 0) === :assign))
        |> first_follow(memory_b)

    defp first_follow({[{_, list}], kit}, memory_b),
      do:
        list
        |> Map.new(fn {value, key} -> {key, value} end)
        |> update_memoryb(memory_b)
        |> prefollow_kit(kit)

    defp update_memoryb(map, 0), do: map
    defp update_memoryb(map, value), do: Map.put(map, :b, value)

    defp prefollow_kit(memory, kit),
      do:
        kit
        |> Enum.split_with(fn
          {{key1, key2}, _} -> is_map_key(memory, key1) and is_map_key(memory, key2)
          {key, _} -> is_map_key(memory, key)
        end)
        |> follow_kit(memory, :private)

    defp follow_kit({[], _}, memory, _), do: memory

    defp follow_kit({active_kit, inactive_kit}, memory, _),
      do:
        active_kit
        |> Enum.reduce(memory, &preoperation/2)
        |> prefollow_kit(inactive_kit)

    defp preoperation({source, operations}, memory),
      do:
        Enum.reduce(operations, memory, fn {input, output}, acc ->
          preoperation({source, input, output}, acc)
        end)

    defp preoperation({source, input, output}, memory),
      do:
        input
        |> replace(memory, source)
        |> operation()
        |> save(output, memory)

    defp replace(input, memory, {source1, source2}),
      do:
        input
        |> replace(memory, source1)
        |> replace(memory, source2)

    defp replace(input, memory, source),
      do:
        memory
        |> Map.fetch!(source)
        |> replace(input)

    defp replace(wire1, {operator, nil, wire2}), do: {operator, wire1, wire2}
    defp replace(wire2, {operator, wire1, nil}), do: {operator, wire1, wire2}
    defp replace(wire1, {operator, nil}), do: {operator, wire1}

    defp operation({:rshift, number1, number2}), do: Bitwise.>>>(number1, number2)
    defp operation({:lshift, number1, number2}), do: Bitwise.<<<(number1, number2)
    defp operation({:or, number1, number2}), do: Bitwise.|||(number1, number2)
    defp operation({:and, number1, number2}), do: Bitwise.&&&(number1, number2)
    defp operation({:not, number1}), do: Bitwise.bnot(number1)
    defp operation({:assign, number1}), do: number1

    defp save(result, output, memory), do: Map.put(memory, output, result)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.follow_kit(0)
      |> Map.fetch!(:a)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> double_run()
      |> Map.fetch!(:a)
    end

    defp double_run(kit),
      do:
        kit
        |> Common.follow_kit(0)
        |> new_follow(kit)

    defp new_follow(memory, kit), do: Common.follow_kit(kit, Map.fetch!(memory, :a))
  end
end
