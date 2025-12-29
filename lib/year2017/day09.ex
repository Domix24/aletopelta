defmodule Aletopelta.Year2017.Day09 do
  @moduledoc """
  Day 9 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(binary())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
    end

    @spec traverse(list(binary())) :: {integer(), integer()}
    def traverse(list), do: traverse(list, 0, 0, 0)

    defp traverse(["{" | rest], depth, sum, garbage) do
      new_depth = depth + 1
      {["}" | new_rest], new_sum, new_garbage} = traverse(rest, new_depth, sum, garbage)
      traverse(new_rest, depth, new_sum + new_depth, new_garbage)
    end

    defp traverse(["<" | rest], depth, sum, garbage) do
      {[">" | new_rest], new_garbage} = trash(rest, garbage)
      traverse(new_rest, depth, sum, new_garbage)
    end

    defp traverse(["}", ",", "{" | rest], depth, sum, garbage),
      do: traverse(rest, depth, sum + depth, garbage)

    defp traverse(["}" | _] = list, _, sum, garbage), do: {list, sum, garbage}
    defp traverse([_ | rest], depth, sum, garbage), do: traverse(rest, depth, sum, garbage)
    defp traverse([], _, sum, garbage), do: {sum, garbage}

    defp trash(["!", _ | rest], garbage), do: trash(rest, garbage)
    defp trash([">" | _] = list, garbage), do: {list, garbage}
    defp trash([_ | rest], garbage), do: trash(rest, garbage + 1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> elem(1)
    end
  end
end
