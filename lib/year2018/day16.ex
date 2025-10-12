defmodule Aletopelta.Year2018.Day16 do
  @moduledoc """
  Day 16 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: {[{[integer()], [integer()], [integer()]}], [[integer()]]}
    def parse_input(input) do
      input
      |> parse()
      |> Enum.split_with(fn
        {_, _, _} -> true
        _ -> false
      end)
    end

    defp parse([line1, line2, line3, "" | rest]) do
      [register_before, instruction, register_after] = Enum.map([line1, line2, line3], &convert/1)
      final = {register_before, instruction, register_after}

      [final | parse(rest)]
    end

    defp parse(["" | rest]), do: Enum.flat_map(rest, &parse/1)
    defp parse(""), do: []
    defp parse(line), do: [convert(line)]

    defp convert(line),
      do:
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.map(fn [value] -> String.to_integer(value) end)

    @spec find_operations({[integer()], [integer()], [integer()]}) ::
            Enumerable.t({atom(), integer()})
    def find_operations({_, [code | _], _} = match),
      do:
        Stream.flat_map(
          ~w"addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr"a,
          fn operation ->
            if test?(operation, match) do
              [{operation, code}]
            else
              []
            end
          end
        )

    defp test?(operator, {register_before, [_, _, _, i3] = input, register_after}) do
      new_register = execute(operator, register_before, input)

      register(i3, new_register) === register(i3, register_after)
    end

    defp execute_read(:addr, register_before, [_, i1, i2, _]),
      do: operator(:add, register(i1, register_before), register(i2, register_before))

    defp execute_read(:addi, register_before, [_, i1, i2, _]),
      do: operator(:add, register(i1, register_before), i2)

    defp execute_read(:mulr, register_before, [_, i1, i2, _]),
      do: operator(:mul, register(i1, register_before), register(i2, register_before))

    defp execute_read(:muli, register_before, [_, i1, i2, _]),
      do: operator(:mul, register(i1, register_before), i2)

    defp execute_read(:banr, register_before, [_, i1, i2, _]),
      do: operator(:ban, register(i1, register_before), register(i2, register_before))

    defp execute_read(:bani, register_before, [_, i1, i2, _]),
      do: operator(:ban, register(i1, register_before), i2)

    defp execute_read(:borr, register_before, [_, i1, i2, _]),
      do: operator(:bor, register(i1, register_before), register(i2, register_before))

    defp execute_read(:bori, register_before, [_, i1, i2, _]),
      do: operator(:bor, register(i1, register_before), i2)

    defp execute_read(:setr, register_before, [_, i1, _, _]),
      do: operator(:set, register(i1, register_before))

    defp execute_read(:seti, _, [_, i1, _, _]), do: operator(:set, i1)

    defp execute_read(:gtir, register_before, [_, i1, i2, _]),
      do: operator(:gt, i1, register(i2, register_before))

    defp execute_read(:gtri, register_before, [_, i1, i2, _]),
      do: operator(:gt, register(i1, register_before), i2)

    defp execute_read(:gtrr, register_before, [_, i1, i2, _]),
      do: operator(:gt, register(i1, register_before), register(i2, register_before))

    defp execute_read(:eqir, register_before, [_, i1, i2, _]),
      do: operator(:eq, i1, register(i2, register_before))

    defp execute_read(:eqri, register_before, [_, i1, i2, _]),
      do: operator(:eq, register(i1, register_before), i2)

    defp execute_read(:eqrr, register_before, [_, i1, i2, _]),
      do: operator(:eq, register(i1, register_before), register(i2, register_before))

    @spec execute(atom(), [integer()], [integer()]) :: [integer()]
    def execute(operator, register, [_, _, _, i3] = input),
      do:
        operator
        |> execute_read(register, input)
        |> write_register(i3, register)

    defp operator(operator, i1, i2 \\ nil)

    defp operator(:add, i1, i2), do: i1 + i2
    defp operator(:mul, i1, i2), do: i1 * i2
    defp operator(:ban, i1, i2), do: Bitwise.band(i1, i2)
    defp operator(:bor, i1, i2), do: Bitwise.bor(i1, i2)
    defp operator(:set, i, nil), do: i
    defp operator(:gt, i1, i2) when i1 > i2, do: 1
    defp operator(:gt, _, _), do: 0
    defp operator(:eq, i, i), do: 1
    defp operator(:eq, _, _), do: 0

    defp register(0, [value | _]), do: value
    defp register(1, [_, value | _]), do: value
    defp register(2, [_, _, value | _]), do: value
    defp register(3, [_, _, _, value | _]), do: value

    defp write_register(value, 0, [_ | rest]), do: [value | rest]
    defp write_register(value, 1, [register_a, _ | rest]), do: [register_a, value | rest]

    defp write_register(value, 2, [register_a, register_b, _ | rest]),
      do: [register_a, register_b, value | rest]

    defp write_register(value, 3, [register_a, register_b, register_c, _]),
      do: [register_a, register_b, register_c, value]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: any()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> elem(0)
      |> Enum.count(&do_part/1)
    end

    defp do_part(match) do
      final =
        match
        |> Common.find_operations()
        |> Enum.take(3)

      case final do
        [_, _, _] -> final
        _ -> nil
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_part()
      |> Enum.at(0)
    end

    defp do_part({matchlist, program}) do
      matched =
        matchlist
        |> Enum.flat_map(fn match ->
          match
          |> Common.find_operations()
          |> Enum.to_list()
        end)
        |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))

      code_map =
        {[], matched}
        |> continue_match()
        |> Map.new(fn {code, [operation]} -> {code, operation} end)

      Enum.reduce(program, [0, 0, 0, 0], fn [operation | _] = input, acc ->
        found = Map.fetch!(code_map, operation)

        Common.execute(found, acc, input)
      end)
    end

    defp continue_match({matching, []}), do: matching

    defp continue_match({matching, in_match}) do
      list_operations = Enum.map(matching, fn {_, [op]} -> op end)

      {new_matching, inmatch} =
        in_match
        |> Enum.map(fn {code, operations} -> {code, Enum.uniq(operations) -- list_operations} end)
        |> Enum.split_with(fn
          {_, [_]} -> true
          _ -> false
        end)

      continue_match({matching ++ new_matching, inmatch})
    end
  end
end
