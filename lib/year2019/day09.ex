defmodule Aletopelta.Year2019.Day09 do
  @moduledoc """
  Day 9 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type intcode() :: %{integer() => integer()}

    @spec parse_input(input()) :: intcode()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.with_index(fn string, index -> {index, String.to_integer(string)} end)
      |> Map.new()
    end

    defp do_reduce(map, i \\ 0, options, base \\ 0),
      do:
        map
        |> Map.fetch!(i)
        |> parse_operator()
        |> clean_options(options)
        |> follow_command(map, i, base)
        |> update_parameters()

    defp clean_options(operator, options), do: {operator, Map.drop(options, [:state])}

    defp follow_command({operator, options}, map, i, base),
      do: get_command(operator, map, i, options, base)

    defp parse_operator(operator) do
      [smode3, smode2, smode1 | soperator] =
        "#{operator}"
        |> String.pad_leading(5, "0")
        |> String.graphemes()

      noperator =
        soperator
        |> Enum.join("")
        |> String.to_integer()

      {noperator, [smode1, smode2, smode3]}
    end

    defp update_parameters({map, i, %{state: state} = opt, _}) when state in [:stop, :pause],
      do: {map, i, opt}

    defp update_parameters({map, i, opt, base}), do: do_reduce(map, i, opt, base)

    defp get_command({99, _}, map, i, %{output: value} = opt, base) do
      new_map = Map.put(map, 0, value)
      new_opt = Map.put(opt, :state, :stop)

      {new_map, i, new_opt, base}
    end

    defp get_command({command, [mode1, mode2, mode3]}, map, i, opt, base)
         when command in [1, 2, 7, 8] do
      first_value = get_value(map, i + 1, mode1, base)
      second_value = get_value(map, i + 2, mode2, base)

      result = do_operation(command, first_value, second_value)
      new_map = set_value(map, i + 3, mode3, base, result)

      {new_map, i + 4, opt, base}
    end

    defp get_command({3, _}, map, i, %{input: []} = opt, base) do
      new_opt = Map.put(opt, :state, :pause)

      {map, i, new_opt, base}
    end

    defp get_command({3, [mode1 | _]}, map, i, %{input: [value | rest]} = opt, base) do
      new_map = set_value(map, i + 1, mode1, base, value)

      new_opt = Map.put(opt, :input, rest)

      {new_map, i + 2, new_opt, base}
    end

    defp get_command({4, [mode1, _, _]}, map, i, opt, base) do
      first_value = get_value(map, i + 1, mode1, base)

      new_opt = Map.put(opt, :output, first_value)

      {map, i + 2, new_opt, base}
    end

    defp get_command({command, [mode1, mode2, _]}, map, i, opt, base) when command in 5..6 do
      first_value = get_value(map, i + 1, mode1, base)
      second_value = get_value(map, i + 2, mode2, base)

      if jump?(command, first_value) do
        {map, second_value, opt, base}
      else
        {map, i + 3, opt, base}
      end
    end

    defp get_command({9, [mode1 | _]}, map, i, opt, base) do
      first_value = get_value(map, i + 1, mode1, base)

      {map, i + 2, opt, base + first_value}
    end

    defp do_operation(1, param1, param2), do: param1 + param2
    defp do_operation(2, param1, param2), do: param1 * param2

    defp do_operation(7, param1, param2) when param1 < param2, do: 1
    defp do_operation(7, _, _), do: 0

    defp do_operation(8, param1, param1), do: 1
    defp do_operation(8, _, _), do: 0

    defp jump?(5, param), do: param != 0
    defp jump?(6, param), do: param == 0

    defp get_value(map, i, "0", _) do
      position = Map.get(map, i, 0)
      Map.get(map, position, 0)
    end

    defp get_value(map, i, "1", _) do
      Map.get(map, i, 0)
    end

    defp get_value(map, i, "2", base) do
      position = Map.get(map, i, 0)
      Map.get(map, position + base, 0)
    end

    defp set_value(map, i, "0", _, value) do
      position = Map.get(map, i, 0)
      Map.put(map, position, value)
    end

    defp set_value(map, i, "2", base, value) do
      position = Map.get(map, i, 0)
      Map.put(map, position + base, value)
    end

    @spec prepare(intcode(), integer()) :: integer()
    def prepare(map, param1),
      do:
        map
        |> do_reduce(%{input: [param1]})
        |> elem(2)
        |> Map.fetch!(:output)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(2)
    end
  end
end
