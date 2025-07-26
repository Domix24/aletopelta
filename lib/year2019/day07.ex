defmodule Aletopelta.Year2019.Day07 do
  @moduledoc """
  Day 7 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type intcode() :: %{integer() => integer()}
    @type snapshot() :: {intcode(), integer(), map()}

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
        |> clean_options(options)
        |> follow_command(map, i)
        |> update_parameters()

    defp clean_options(operator, options), do: {operator, Map.drop(options, [:state])}
    defp follow_command({operator, options}, map, i), do: get_command(operator, map, i, options)

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

    defp update_parameters({map, i, %{state: state} = opt}) when state in [:stop, :pause],
      do: {map, i, opt}

    defp update_parameters({map, i, opt}), do: do_reduce(map, i, opt)

    defp get_command({99, _}, map, i, %{output: value} = opt) do
      new_map = Map.put(map, 0, value)
      new_opt = Map.put(opt, :state, :stop)

      {new_map, i, new_opt}
    end

    defp get_command({command, [mode1, mode2, _]}, map, i, opt) when command in [1, 2, 7, 8] do
      first_value = get_value(map, i + 1, mode1)
      second_value = get_value(map, i + 2, mode2)
      third_value = get_value(map, i + 3, false)

      result = do_operation(command, first_value, second_value)

      new_map = Map.put(map, third_value, result)

      {new_map, i + 4, opt}
    end

    defp get_command({3, _}, map, i, %{input: []} = opt) do
      new_opt = Map.put(opt, :state, :pause)

      {map, i, new_opt}
    end

    defp get_command({3, _}, map, i, %{input: [value | rest]} = opt) do
      first_value = get_value(map, i + 1, false)

      new_map = Map.put(map, first_value, value)
      new_opt = Map.put(opt, :input, rest)

      {new_map, i + 2, new_opt}
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

    @spec prepare(intcode(), integer(), integer()) :: snapshot()
    def prepare(map, param1, param2), do: do_reduce(map, %{input: [param1, param2]})

    @spec prepare(snapshot(), integer()) :: snapshot()
    def prepare({map, i, _}, param1), do: do_reduce(map, i, %{input: [param1]})

    @spec permute(list(integer())) :: list(list(integer()))
    def permute([]), do: [[]]

    def permute(numbers) do
      for number <- numbers,
          rest <- permute(numbers -- [number]) do
        [number | rest]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
    end

    defp prepare(input) do
      0..4
      |> Enum.to_list()
      |> Common.permute()
      |> Enum.map(&start(&1, input))
      |> Enum.max()
    end

    defp start(phases, input) do
      Enum.reduce(phases, 0, fn phase, last ->
        input
        |> Common.prepare(phase, last)
        |> elem(2)
        |> Map.fetch!(:output)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
    end

    defp prepare(input) do
      5..9
      |> Enum.to_list()
      |> Common.permute()
      |> Enum.map(&start(&1, input))
      |> Enum.max()
    end

    defp start(signals, input) do
      signals
      |> Enum.reduce({[], 0}, fn phase, {acc_list, last} ->
        result = Common.prepare(input, phase, last)
        {_, _, %{output: output}} = result
        {[result | acc_list], output}
      end)
      |> do_loop()
    end

    defp do_loop({list, last_signal}) do
      list
      |> Enum.reverse()
      |> Enum.reduce({[], last_signal}, fn amplifier, {acc_list, last} ->
        result = Common.prepare(amplifier, last)
        {_, _, %{output: output}} = result
        {[result | acc_list], output}
      end)
      |> handle_continue()
    end

    defp handle_continue({list, signal}),
      do:
        list
        |> Enum.any?(fn {_, _, %{state: state}} -> state == :pause end)
        |> continue_loop(list, signal)

    defp continue_loop(true, list, signal), do: do_loop({list, signal})
    defp continue_loop(false, _, signal), do: signal
  end
end
