defmodule Aletopelta.Year2023.Day04 do
  @moduledoc """
  Day x of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day x
    """
    def parse_input([]), do: []

    def parse_input([line | others]) do
      [_, line] = String.split(line, ":")

      [numbers, winning] =
        String.split(line, "|")
        |> Enum.map(&String.split/1)

      [[numbers, winning] | parse_input(others)]
    end

    def get_winning([]), do: []

    def get_winning([[numbers, winning] | others]) do
      count =
        Enum.count(numbers, fn number ->
          Enum.any?(winning, &(&1 == number))
        end)

      [count | get_winning(others)]
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.get_winning()
      |> Enum.sum_by(fn
        1 -> 1
        number when number > 1 -> 2 ** (number - 1)
        _ -> 0
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 1 of Day 4
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.get_winning()
      |> Enum.with_index(&{&2, &1, 1})
      |> build_count
    end

    defp build_count([]), do: 0
    defp build_count([{_, 0, copy} | others]), do: copy + build_count(others)

    defp build_count([{index, count, copy} | others]) do
      others = build_count(others, index + count + 1, copy)
      copy + build_count(others)
    end

    defp build_count([], _, _), do: []
    defp build_count([{max, _, _} | _] = list, max, _), do: list

    defp build_count([{index, count, copy} | others], max, parent_copy) do
      [{index, count, parent_copy + copy} | build_count(others, max, parent_copy)]
    end
  end
end
