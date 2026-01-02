defmodule Aletopelta.Year2017.Day17 do
  @moduledoc """
  Day 17 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: integer()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> take_next()
    end

    defp do_loop(steps),
      do:
        Enum.reduce(1..2017, {[0], 0}, fn insert, {list, position} ->
          new_position = rem(position + steps, length(list)) + 1
          {left, right} = Enum.split(list, new_position)

          {Enum.concat(left, [insert | right]), new_position}
        end)

    defp take_next({list, next}), do: Enum.at(list, next + 1)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> elem(1)
    end

    defp do_loop(steps),
      do:
        Enum.reduce(1..50_000_000, {0, 0}, fn insert, {position, after_zero} ->
          new_position = rem(position + steps, insert) + 1

          new_afterzero =
            if new_position === 1 do
              insert
            else
              after_zero
            end

          {new_position, new_afterzero}
        end)
  end
end
