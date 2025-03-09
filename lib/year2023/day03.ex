defmodule Aletopelta.Year2023.Day03 do
  @moduledoc """
  Day 3 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """
    def parse_input(input) do
      Enum.with_index(input, fn line, y ->
        String.graphemes(line)
        |> Enum.with_index(fn cell, x ->
          create_cell(cell, x, y)
        end)
        |> Enum.reject(&(elem(&1, 2) == :error))
      end)
      |> Enum.flat_map(& &1)
      |> Map.new(&{{elem(&1, 0), elem(&1, 1)}, {elem(&1, 2), elem(&1, 3)}})
    end

    defp create_cell(<<cell>>, x, y) do
      cond do
        ?0 <= cell and cell <= ?9 -> {x, y, :number, <<cell>>}
        ?. == cell -> {0, 0, :error, <<0>>}
        true -> {x, y, :symbol, <<cell>>}
      end
    end

    def get_next({x, y})  do
      [{x + 1, y - 1},
       {x + 1, y + 0},
       {x + 1, y + 1},
       {x + 0, y + 1},
       {x - 1, y + 1},
       {x - 1, y - 0},
       {x - 1, y - 1},
       {x - 0, y - 1}]
    end

    def merge_similar(positions) do
      merge_similar(positions, :y)
    end
    defp merge_similar(positions, :y) do
      Enum.group_by(positions, &elem(&1, 1))
      |> Enum.flat_map(fn
        {y, [{x1, _}, {x2, _}] = group} ->
          cond do
            x1 + 1 == x2 -> [{x1, y}]
            x1 - 1 == x2 -> [{x2, y}]
            true -> group
          end
        {y, [{x1, _}, {x2, _}, {x3, _}]} -> [{min(x1, min(x2, x3)), y}]
        {_, group} -> group
      end)
    end

    def find_number(positions, input) do
      positions
      |> Enum.map(&find_number(&1, input, :x1))
      |> Enum.map(&String.to_integer/1)
    end
    defp find_number({x, y}, input, :x1) do
      if match?({:number, _}, Map.get(input, {x - 1, y})) do
        find_number({x - 1, y}, input, :x1)
      else
        "#{elem(Map.get(input, {x, y}), 1)}#{find_number({x, y}, input, :x2)}"
      end
    end
    defp find_number({x, y}, input, :x2) do
      if match?({:number, _}, Map.get(input, {x + 1, y})) do
        "#{elem(Map.get(input, {x + 1, y}), 1)}#{find_number({x + 1, y}, input, :x2)}"
      else
        ""
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    def execute(input) do
      Common.parse_input(input)
      |> find_part
      |> Enum.sum
    end

    defp find_part(input) do
      Map.filter(input, fn {_, value} -> elem(value, 0) == :symbol end)
      |> Enum.flat_map(fn {key, _} ->
        Common.get_next(key)
        |> Enum.filter(&match?({:number, _}, Map.get(input, &1)))
        |> Common.merge_similar
        |> Common.find_number(input)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 1 of Day 3
    """
    def execute(input) do
      Common.parse_input(input)
      |> find_part
      |> Enum.sum
    end

    defp find_part(input) do
      Map.filter(input, fn {_, value} -> elem(value, 1) == "*" end)
      |> Enum.flat_map(fn {key, _} ->
        Common.get_next(key)
        |> Enum.filter(&match?({:number, _}, Map.get(input, &1)))
        |> Common.merge_similar
        |> keep_two
        |> Common.find_number(input)
        |> multiply
      end)
    end

    defp keep_two([_, _] = list), do: list
    defp keep_two(_), do: []

    defp multiply([number1, number2]), do: [number1 * number2]
    defp multiply(_), do: [0]
  end
end
