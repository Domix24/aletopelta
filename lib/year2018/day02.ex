defmodule Aletopelta.Year2018.Day02 do
  @moduledoc """
  Day 2 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.graphemes/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.reduce([0, 0], fn line, acc ->
        line
        |> Enum.frequencies()
        |> Enum.group_by(&elem(&1, 1))
        |> Enum.filter(fn {key, _} -> key in 2..3 end)
        |> Enum.reduce(acc, fn
          {2, _}, [a, b] -> [a + 1, b]
          {3, _}, [a, b] -> [a, b + 1]
        end)
      end)
      |> Enum.product()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> combination()
      |> Enum.find_value(fn {word1, word2} ->
        word1
        |> Stream.transform(fn -> {0, word2, []} end, &transform/2, &emit/1, fn _ -> nil end)
        |> Enum.to_list()
        |> then(fn
          [] -> false
          list -> list
        end)
      end)
      |> Enum.join()
    end

    defp combination(list) do
      Stream.transform(list, list, fn _, [actual | rest] ->
        {Stream.map(rest, &{actual, &1}), rest}
      end)
    end

    defp transform(letter, {n, [letter | rest], final}), do: {[], {n, rest, [letter | final]}}
    defp transform(_, {1, _, _}), do: {:halt, nil}
    defp transform(_, {0, [_ | rest], final}), do: {[], {1, rest, final}}

    defp emit({1, [], reversed}), do: {Enum.reverse(reversed), nil}
    defp emit(_), do: {[], nil}
  end
end
