defmodule Aletopelta.Year2017.Day16 do
  @moduledoc """
  Day 16 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())
    @type output() :: binary()
    @type move() :: {:s, integer()} | {:p | :x, integer(), integer()}

    @spec parse_input(input()) :: list(move())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(fn part ->
        case String.split_at(part, 1) do
          {"s", rest} ->
            {:s, String.to_integer(rest)}

          {"p", rest} ->
            [from, to] = String.split(rest, "/")
            {:p, from, to}

          {"x", rest} ->
            [from, to] =
              rest
              |> String.split("/")
              |> Enum.map(&String.to_integer/1)

            {:x, from, to}
        end
      end)
    end

    @spec dance(list(move()), list(binary())) :: list(binary())
    def dance(parsed, programs) do
      Enum.reduce(parsed, programs, fn
        {:s, number}, acc ->
          spin(number, acc)

        {:x, from, to}, acc ->
          from
          |> exchange(to, acc)
          |> build(acc)

        {:p, from, to}, acc ->
          from
          |> partner(to, acc)
          |> build(acc)
      end)
    end

    defp spin(number, list) do
      {new_end, new_front} = Enum.split(list, -number)
      new_front ++ new_end
    end

    defp exchange(from, to, list) do
      [f, t] = Enum.sort([from, to])
      from_program = Enum.at(list, f)
      to_program = Enum.at(list, t)

      {from_program, to_program}
    end

    defp partner(from, to, list) do
      from_index = Enum.find_index(list, &(&1 === from))
      to_index = Enum.find_index(list, &(&1 === to))

      [from_program, to_program] =
        [{from, from_index}, {to, to_index}]
        |> Enum.sort_by(&elem(&1, 1))
        |> Enum.map(&elem(&1, 0))

      {from_program, to_program}
    end

    defp build({from, to}, list) do
      {from_unused, [from | rest]} = Enum.split_while(list, &(!(&1 === from)))
      {to_unused, [to | new_rest]} = Enum.split_while(rest, &(!(&1 === to)))

      from_unused ++ [to] ++ to_unused ++ [from] ++ new_rest
    end

    @spec program() :: list(binary())
    def program, do: Enum.map(0..15, &<<&1 + ?a>>)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.dance(Common.program())
      |> Enum.join()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_dance()
      |> Enum.join()
    end

    defp do_dance(parsed) do
      Enum.reduce_while(1..1_000_000_000, {Map.new(), Common.program()}, fn index,
                                                                            {seen, program} ->
        seen
        |> Map.get(program)
        |> continue_dance(seen, program, index, parsed)
      end)
    end

    defp continue_dance(nil, seen, program, index, parsed) do
      new_seen = Map.put(seen, program, index)
      new_program = Common.dance(parsed, program)
      {:cont, {new_seen, new_program}}
    end

    defp continue_dance(cycle, seen, _, index, _) do
      cycle_length = index - cycle
      remain = rem(1_000_000_000, cycle_length) + 1

      {found, _} = Enum.find(seen, fn {_, position} -> position === remain end)

      {:halt, found}
    end
  end
end
