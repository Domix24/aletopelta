defmodule Aletopelta.Year2022.Day05 do
  @moduledoc """
  Day 5 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """
    @spec parse_input(any()) :: {any(), list()}
    def parse_input(input) do
      {stacks, moves} =
        Enum.reduce(input, {[], []}, fn line, {stacks, moves} ->
          case String.at(line, 0) do
            "[" ->
              stacks = push_row(line, stacks)
              {stacks, moves}

            " " ->
              stacks = map_stacks(line, stacks)
              {stacks, moves}

            "m" ->
              move = get_moves(line)
              {stacks, [move | moves]}

            nil ->
              {stacks, moves}
          end
        end)

      {stacks, Enum.reverse(moves)}
    end

    defp add_row([], _), do: []

    defp add_row([box | boxes], []) do
      [box | add_row(boxes, [])]
    end

    defp add_row([[box] | boxes], [stack | stacks]) do
      [[box | stack] | add_row(boxes, stacks)]
    end

    defp tag_stacks([], _), do: []

    defp tag_stacks([number | numbers], [stack | stacks]) do
      stack =
        stack
        |> Enum.reject(&(&1 == "    "))
        |> Enum.reverse()

      [{number, stack} | tag_stacks(numbers, stacks)]
    end

    defp get_moves(line) do
      ~r/\d+/
      |> Regex.scan(line)
      |> Enum.map(fn [number] -> String.to_integer(number) end)
    end

    defp map_stacks(line, stacks) do
      ~r/\d/
      |> Regex.scan(line)
      |> Enum.map(fn [number] -> String.to_integer(number) end)
      |> tag_stacks(stacks)
      |> Map.new()
    end

    defp push_row(line, stacks) do
      ~r/(\w)|(\s{4})/
      |> Regex.scan(line, capture: :first)
      |> add_row(stacks)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(any()) :: binary()
    def execute(input) do
      {stacks, moves} = Common.parse_input(input)

      moves
      |> Enum.reduce(stacks, fn [quantity, source, destination], stacks ->
        {grab, left} =
          stacks
          |> Map.fetch!(source)
          |> Enum.split(quantity)

        pile = Enum.reverse(grab)

        stacks
        |> Map.put(source, left)
        |> Map.update!(destination, &(pile ++ &1))
      end)
      |> Enum.map_join(fn {_, [box | _]} -> box end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(any()) :: binary()
    def execute(input) do
      {stacks, moves} = Common.parse_input(input)

      moves
      |> Enum.reduce(stacks, fn [quantity, source, destination], stacks ->
        {grab, left} =
          stacks
          |> Map.fetch!(source)
          |> Enum.split(quantity)

        stacks
        |> Map.put(source, left)
        |> Map.update!(destination, &(grab ++ &1))
      end)
      |> Enum.map_join(fn {_, [box | _]} -> box end)
    end
  end
end
