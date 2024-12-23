defmodule Aletopelta.Day20241217 do
  import Bitwise

  defmodule Common do
  end

  defmodule Part1 do
    @register_pattern ~r/([A-C]{1}): (\d+)/
    @program_pattern ~r/(\d)+/

    def execute(input \\ nil) do
      input
      |> parse_input
      |> execute_program
      |> Enum.join(",")
    end

    defp execute_program({register, program}) do
      execute_program(register, program, program)
    end

    defp execute_program(_, [], _), do: []

    defp execute_program(register, [first, second | rest], full) do
      result = execute_command(register, first, second)

      case result do
        {:jump, nil} -> execute_program(register, rest, full)
        {:jump, number} -> execute_program(register, Enum.drop(full, number), full)
        {:out, number} -> [number | execute_program(register, rest, full)]
        _ -> execute_program(result, rest, full)
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

    defp parse_input(input) do
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
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
