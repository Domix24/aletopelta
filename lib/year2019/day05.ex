defmodule Aletopelta.Year2019.Day05 do
  @moduledoc """
  Day 5 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
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

    defp do_reduce(map, i \\ 0, options),
      do:
        map
        |> Map.fetch!(i)
        |> parse_operator()
        |> get_command(map, i, options)
        |> update_parameters()

    defp parse_operator(operator) do
      [smode3, smode2, smode1 | soperator] =
        "#{operator}"
        |> String.pad_leading(5, "0")
        |> String.graphemes()

      noperator =
        soperator
        |> Enum.join("")
        |> String.to_integer()

      {noperator, [smode1 == "0", smode2 == "0", smode3 == "0"]}
    end

    defp update_parameters({map, :stop, _}), do: map
    defp update_parameters({map, i, opt}), do: do_reduce(map, i, opt)

    defp get_command({99, _}, map, _, %{output: value} = opt) do
      new_map = Map.put(map, 0, value)

      {new_map, :stop, opt}
    end

    defp get_command({command, [mode1, mode2, _]}, map, i, opt) when command in [1, 2, 7, 8] do
      first_value = get_value(map, i + 1, mode1)
      second_value = get_value(map, i + 2, mode2)
      third_value = get_value(map, i + 3, false)

      result = do_operation(command, first_value, second_value)

      new_map = Map.put(map, third_value, result)

      {new_map, i + 4, opt}
    end

    defp get_command({3, _}, map, i, %{input: value} = opt) do
      first_value = get_value(map, i + 1, false)

      new_map = Map.put(map, first_value, value)

      {new_map, i + 2, opt}
    end

    defp get_command({4, [mode1, _, _]}, map, i, opt) do
      first_value = get_value(map, i + 1, mode1)

      new_opt = Map.put(opt, :output, first_value)

      {map, i + 2, new_opt}
    end

    defp get_command({command, [mode1, mode2, _]}, map, i, opt) when command in 5..6 do
      first_value = get_value(map, i + 1, mode1)
      second_value = get_value(map, i + 2, mode2)

      if jump?(command, first_value) do
        {map, second_value, opt}
      else
        {map, i + 3, opt}
      end
    end

    defp do_operation(1, param1, param2), do: param1 + param2
    defp do_operation(2, param1, param2), do: param1 * param2

    defp do_operation(7, param1, param2) when param1 < param2, do: 1
    defp do_operation(7, _, _), do: 0

    defp do_operation(8, param1, param1), do: 1
    defp do_operation(8, _, _), do: 0

    defp jump?(5, param), do: param != 0
    defp jump?(6, param), do: param == 0

    defp get_value(map, i, true) do
      position = Map.fetch!(map, i)
      Map.fetch!(map, position)
    end

    defp get_value(map, i, false) do
      Map.fetch!(map, i)
    end

    @spec prepare(intcode(), integer()) :: integer()
    def prepare(map, param),
      do:
        map
        |> do_reduce(%{input: param})
        |> Map.fetch!(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
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
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(5)
    end
  end
end
