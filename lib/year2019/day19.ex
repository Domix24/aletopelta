defmodule Aletopelta.Year2019.Day19 do
  @moduledoc """
  Day 19 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())
    @type intcode() :: %{integer() => integer()}
    @type point() :: {integer(), integer()}
    @type grid() :: %{point() => integer()}

    @spec parse_input(input()) :: intcode()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.with_index(fn string, index -> {index, String.to_integer(string)} end)
      |> Map.new()
    end

    defp do_reduce(map, i, options, base),
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

    defp update_parameters({map, i, %{state: state} = opt, base}) when state in [:stop, :pause],
      do: {map, i, opt, base}

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

      new_opt = Map.update(opt, :output, [first_value], &[first_value | &1])

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

    @spec prepare(intcode(), [integer()], integer(), integer()) ::
            {%{program: intcode(), index: integer(), base: integer()}, [integer()],
             :stop | :pause}
    def prepare(map, input, index, base),
      do:
        map
        |> do_reduce(index, %{input: input}, base)
        |> format_output()

    defp format_output({program, index, %{output: output, state: state}, base}),
      do: {%{program: program, index: index, base: base}, output, state}

    @spec prepare(intcode(), {integer(), integer()}) ::
            {%{program: intcode(), index: integer(), base: integer()}, [integer()],
             :stop | :pause}
    def prepare(map, {x, y}), do: prepare(map, [x, y], 0, 0)

    @spec beam?({integer(), integer()}, intcode()) :: boolean()
    def beam?(input, intcode),
      do:
        intcode
        |> prepare(input)
        |> elem(1)
        |> Kernel.===([1])
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> build_grid()
      |> Enum.sum_by(&Range.size(elem(&1, 1)))
    end

    defp build_grid(intcode, square \\ 50) do
      0..(square - 1)
      |> Stream.transform({-1, 0}, fn x, {last_min, last_size} = last_acc ->
        new_min =
          (last_min + 1)
          |> Range.new(min(last_min + 4, square - 1), 1)
          |> Enum.find(&Common.beam?({x, &1}, intcode))

        cond do
          !is_nil(new_min) and new_min > 0 and is_nil(last_size) ->
            process_max(nil, new_min, square, x)

          new_min ->
            new_min
            |> Range.new(min(new_min + last_size + 1, square - 1))
            |> Enum.find(&(!Common.beam?({x, &1}, intcode)))
            |> process_max(new_min, square, x)

          x > 2 ->
            {:halt, nil}

          true ->
            {[], last_acc}
        end
      end)
    end

    defp process_max(new_max, new_min, _, x) when not is_nil(new_max),
      do: {[{x, Range.new(new_min, new_max - 1)}], {new_min, new_max - new_min}}

    defp process_max(_, new_min, square, x),
      do: {[{x, Range.new(new_min, square - 1)}], {new_min, nil}}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_ship()
      |> then(fn {x, y} -> x * 10_000 + y end)
    end

    defp find_ship(intcode, start \\ {900, 1400}, size \\ 100),
      do:
        intcode
        |> get_rows(start)
        |> Enum.find_value(fn {x, y} -> ship?({x, y}, size, intcode) end)

    defp ship?(position, size, intcode),
      do:
        position
        |> build_corners(size)
        |> Enum.take(2)
        |> Enum.all?(&Common.beam?(&1, intcode))
        |> topleft(position, size)

    defp build_corners({x, y}, size),
      do: [{x + size - 1, y}, {x + size - 1, y - size + 1}, {x, y - size + 1}]

    defp topleft(false, _, _), do: false

    defp topleft(true, position, size),
      do:
        position
        |> build_corners(size)
        |> Enum.at(2)

    defp get_rows(intcode, {_, size} = start),
      do:
        start
        |> get_row(intcode)
        |> then(fn x -> {x, size} end)
        |> Stream.iterate(fn {x, y} ->
          new_x = get_row({x, y + 1}, intcode)
          {new_x, y + 1}
        end)

    defp get_row({x, y}, intcode),
      do:
        x
        |> Stream.iterate(&(&1 + 1))
        |> Enum.find(fn sx -> Common.beam?({sx, y}, intcode) end)
  end
end
