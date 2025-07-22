defmodule Aletopelta.Year2019.Day02 do
  @moduledoc """
  Day 2 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
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

    defp replace_input(map, param1, param2),
      do:
        map
        |> Map.put(1, param1)
        |> Map.put(2, param2)

    defp do_reduce(map, i \\ 0),
      do:
        map
        |> Map.fetch!(i)
        |> get_command(map, i)
        |> update_parameters()

    defp update_parameters({map, :stop}), do: map
    defp update_parameters({map, i}), do: do_reduce(map, i)

    defp get_command(99, map, _), do: {map, :stop}

    defp get_command(command, map, i) do
      first_value = get_value(map, i + 1)
      second_value = get_value(map, i + 2)

      third_position = Map.fetch!(map, i + 3)
      third_value = do_operation(command, first_value, second_value)

      new_map = Map.put(map, third_position, third_value)

      {new_map, i + 4}
    end

    defp do_operation(1, param1, param2), do: param1 + param2
    defp do_operation(2, param1, param2), do: param1 * param2

    defp get_value(map, i) do
      position = Map.fetch!(map, i)
      Map.fetch!(map, position)
    end

    @spec prepare(intcode(), integer(), integer()) :: integer()
    def prepare(map, param1, param2),
      do:
        map
        |> replace_input(param1, param2)
        |> do_reduce()
        |> Map.fetch!(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(12, 2)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop(19_690_720)
      |> then(fn {noun, verb} -> noun * 100 + verb end)
    end

    defp prepare_loop(map, expected) do
      0
      |> Stream.iterate(&(&1 + 1))
      |> Enum.find_value(&find_value(&1, map, expected))
    end

    defp find_value(number, map, expected) when is_integer(number),
      do: find_value({div(number, 100), rem(number, 100)}, map, expected)

    defp find_value({number1, number2} = pair, map, expected),
      do:
        map
        |> Common.prepare(number1, number2)
        |> then(fn
          ^expected -> pair
          _ -> nil
        end)
  end
end
