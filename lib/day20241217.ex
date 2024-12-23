defmodule Aletopelta.Day20241217 do
  import Bitwise

  defmodule Common do
    @register_pattern ~r/([A-C]{1}): (\d+)/
    @program_pattern ~r/(\d)+/

    def parse_input(input) do
     parse_input(input, %{}, [])
    end

    defp parse_input([], register, program) do
      {register, Enum.reverse(program)}
    end

    defp parse_input([first | rest], register, program) do
      register_result = Regex.scan(@register_pattern, first)

      {register, program} = case register_result do
        [] ->
          program_result = Regex.scan(@program_pattern, first)
          case program_result do
            [] -> {register, program}
            _ -> {register, Enum.reduce(program_result, [], fn [_, digit], acc ->
                [String.to_integer(digit) | acc]
              end)}
          end
        [[_, name, number]] -> {Map.put(register, name, String.to_integer(number)), program}
      end

      parse_input(rest, register, program)
    end

    def execute_program({register, program}) do
      execute_program({register, program, length(program) + 1})
    end

    def execute_program({register, program, max}) do
      execute_program(register, program, program, 0, max)
    end

    defp execute_program(_, [], _, _, _), do: []

    defp execute_program(register, [first, second | rest], full, index, max) do
      result = execute_command(register, first, second)

      case result do
        {:jump, nil} -> execute_program(register, rest, full, index, max)
        {:jump, number} -> execute_program(register, Enum.drop(full, number), full, index, max)
        {:out, number} -> case index do
          ^max -> [number]
          _ -> [number | execute_program(register, rest, full, index + 1, max)]
        end
        _ -> execute_program(result, rest, full, index, max)
      end
    end

    defp execute_command(register, 0, first) do
      Map.update!(register, "A", &div(&1, trunc(:math.pow(2, get_combo(register, first)))))
    end

    defp execute_command(register, 1, first) do
      Map.update!(register, "B", &bxor(&1, first))
    end

    defp execute_command(register, 2, first) do
      Map.update!(register, "B", &(&1 * 0 + rem(get_combo(register, first), 8)))
    end

    defp execute_command(register, 3, first) do
      case get_combo(register, 4) do
        0 -> {:jump, nil}
        _ -> {:jump, first}
      end
    end

    defp execute_command(register, 4, _) do
      Map.update!(register, "B", &bxor(&1, get_combo(register, 6)))
    end

    defp execute_command(register, 5, first) do
      {:out, rem(get_combo(register, first), 8)}
    end

    defp execute_command(register, 6, first) do
      Map.update!(register, "B", &div(&1 * 0 + get_combo(register, 4), trunc(:math.pow(2, get_combo(register, first)))))
    end

    defp execute_command(register, 7, first) do
      Map.update!(register, "C", &div(&1 * 0 + get_combo(register, 4), trunc(:math.pow(2, get_combo(register, first)))))
    end

    defp get_combo(register, 4), do: Map.get(register, "A")
    defp get_combo(register, 5), do: Map.get(register, "B")
    defp get_combo(register, 6), do: Map.get(register, "C")
    defp get_combo(_, number), do: number
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> Common.execute_program
      |> Enum.join(",")
    end
  end

  defmodule Part2 do
    def execute(input) do
      {register, program} = Common.parse_input(input)

      prepare_loop(register, program, program |> Enum.reverse, Range.to_list(0..7), 0)
      |> Enum.find(fn possible ->
        Common.execute_program({initialize_register(register, possible), program}) == program
      end)
    end

    defp initialize_register(register, a) do
      register
      |> Map.put("A", a)
      |> Map.put("B", 0)
      |> Map.put("C", 0)
    end

    defp prepare_loop(_, program, _, a, index) when length(program) - 1 == index do
      a
    end

    defp prepare_loop(register, program, reverse, a, index) do
      values = a
      |> Enum.filter(fn register_a ->
        Common.execute_program({initialize_register(register, register_a), program, index}) |> Enum.reverse |> Enum.at(index) == reverse |> Enum.at(index)
      end)
      |> Enum.flat_map(&((&1 * 8)..(&1 * 8 + 7)))

      prepare_loop(register, program, reverse, values, index + 1)
    end
  end
end
