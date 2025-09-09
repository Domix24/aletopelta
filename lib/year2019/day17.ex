defmodule Aletopelta.Year2019.Day17 do
  @moduledoc """
  Day 17 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())
    @type point() :: {integer(), integer()}
    @type grid() :: %{point() => integer()}

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec build_grid(Intcode.intcode()) :: grid()
    def build_grid(intcode) do
      memory = Map.new(program: intcode, index: 0, base: 0)

      memory
      |> Intcode.continue()
      |> elem(1)
      |> Enum.reverse()
      |> Enum.chunk_by(&(&1 == 10))
      |> Enum.reject(fn [tile | _] -> tile == 10 end)
      |> create_grid()
    end

    defp create_grid(list),
      do:
        list
        |> Enum.reduce({0, []}, fn line, {y, acc_list} ->
          {_, new_list} =
            Enum.reduce(line, {0, acc_list}, fn cell, {x, acc_sublist} ->
              {x + 1, [{{x, y}, cell} | acc_sublist]}
            end)

          {y + 1, new_list}
        end)
        |> elem(1)
        |> Enum.reject(&(elem(&1, 1) == 46))
        |> Map.new()
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_grid()
      |> find_intersections()
      |> Enum.sum_by(fn {{x, y}, _} -> x * y end)
    end

    defp find_intersections(grid),
      do:
        Enum.filter(grid, fn {{x, y}, _} ->
          count =
            [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
            |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
            |> Enum.count(&(Map.get(grid, &1) != nil))

          count == 4
        end)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
      |> elem(1)
      |> Enum.at(0)
    end

    defp prepare(intcode) do
      grid = Common.build_grid(intcode)

      {main, functions} =
        grid
        |> Enum.find_value(&find_robot/1)
        |> build_path(grid)
        |> split()

      ready_functions = Enum.map(functions, &to_ascii/1)
      ready_main = to_ascii(main)

      new_intcode = Map.put(intcode, 0, 2)
      memory = Map.new(program: new_intcode, index: 0, base: 0)

      Enum.reduce([ready_main | ready_functions] ++ [[?n, 10]], {memory, nil}, fn input,
                                                                                  {acc, _} ->
        {program, output, _} = Intcode.continue(acc, input)

        {program, output}
      end)
    end

    defp find_robot({_, 35}), do: nil
    defp find_robot({position, facing}), do: {position, to_number(facing)}

    defp to_ascii(list),
      do:
        list
        |> Enum.flat_map(&get_ascii/1)
        |> push_newline()

    defp get_ascii({:left, number}),
      do: Enum.reverse([?, | Enum.reverse([?L, ?, | get_ascii(number, :digit)])])

    defp get_ascii({:right, number}),
      do: Enum.reverse([?, | Enum.reverse([?R, ?, | get_ascii(number, :digit)])])

    defp get_ascii(letter), do: [letter + ?A, ?,]

    defp get_ascii(number, :digit),
      do:
        number
        |> Integer.digits()
        |> Enum.map(&(?0 + &1))

    defp push_newline(ascii) do
      [_ | reversed] = Enum.reverse(ascii)
      Enum.reverse([10 | reversed])
    end

    defp split(operations) do
      parts =
        operations
        |> get_parts()
        |> Enum.frequencies()
        |> Enum.filter(&(elem(&1, 1) > 1))
        |> Enum.with_index(&{elem(&1, 0), &2})

      parts
      |> combine_parts()
      |> Enum.find_value(fn list ->
        state =
          list
          |> Enum.with_index()
          |> do_match(operations)

        if Enum.all?(state, &is_integer/1) do
          {state, list}
        end
      end)
    end

    defp combine_parts(parts),
      do:
        Stream.flat_map(parts, fn {a, ai} ->
          parts
          |> Stream.drop(ai + 1)
          |> Stream.flat_map(fn {b, bi} ->
            parts
            |> Stream.drop(bi + 1)
            |> Stream.map(fn {c, _} -> [a, b, c] end)
          end)
        end)

    defp get_parts(operations) do
      size = length(operations)

      for start <- 0..(size - 1),
          stop <- 1..(size - start) do
        operations
        |> Enum.drop(start)
        |> Enum.take(stop)
      end
    end

    defp do_match([_, _, _] = matches, operations),
      do: Enum.reduce(matches, operations, &do_match/2)

    defp do_match({match, index}, operations), do: do_match(operations, match, match, index, [])

    defp do_match([], [], _, replace, _), do: [replace]
    defp do_match([], _, _, _, final), do: Enum.reverse(final)

    defp do_match(list, [], copy, replace, _) do
      [replace | do_match(list, copy, copy, replace, [])]
    end

    defp do_match([value | rest], [value | match], copy, replace, final) do
      do_match(rest, match, copy, replace, [value | final])
    end

    defp do_match([value | rest], copy, copy, replace, final) do
      list = [value | do_match(rest, copy, copy, replace, [])]
      Enum.reverse(final) ++ list
    end

    defp do_match(list, _, copy, replace, final) do
      Enum.reverse(final) ++ do_match(list, copy, copy, replace, [])
    end

    defp to_number(94), do: 0
    defp to_number(118), do: 2
    defp to_number(60), do: 3
    defp to_number(62), do: 1

    defp build_path(robot, grid) do
      result =
        Enum.reduce_while([:right, :left], [], fn head, _ ->
          new_position = move_robot(robot, head)

          if forward?(new_position, grid) do
            {:halt, {new_position, head}}
          else
            {:cont, nil}
          end
        end)

      case result do
        nil ->
          []

        result ->
          result
          |> follow_path(grid, 1)
          |> continue_path(grid)
      end
    end

    defp move_robot({{x, y}, facing}, :right), do: {{x, y}, rem(facing + 1, 4)}
    defp move_robot({{x, y}, facing}, :left), do: {{x, y}, rem(facing + 3, 4)}

    defp step(position, step \\ 1)

    defp step({{x, y}, 0}, step), do: {x, y - step}
    defp step({{x, y}, 1}, step), do: {x + step, y}
    defp step({{x, y}, 2}, step), do: {x, y + step}
    defp step({{x, y}, 3}, step), do: {x - step, y}

    defp forward?(robot, grid), do: Map.has_key?(grid, step(robot))

    defp follow_path({{_, facing} = position, rotation} = full_position, grid, length) do
      new_position = step(position, length + 1)

      if Map.has_key?(grid, new_position) do
        follow_path(full_position, grid, length + 1)
      else
        {rotation, length, step(position, length), facing}
      end
    end

    defp continue_path({rotation, length, position, facing}, grid) do
      [{rotation, length} | build_path({position, facing}, grid)]
    end
  end
end
