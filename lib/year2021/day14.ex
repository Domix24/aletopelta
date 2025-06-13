defmodule Aletopelta.Year2021.Day14 do
  @moduledoc """
  Day 14 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: [binary()]
    @type polymer() :: binary()
    @type pairs() :: %{binary() => binary()}

    @spec parse_input(input()) :: {polymer(), pairs()}
    def parse_input(input) do
      {[polymer], ["" | pairs]} = Enum.split_while(input, &(&1 !== ""))

      new_pairs =
        Map.new(pairs, fn line ->
          [[pair], [insert]] = Regex.scan(~r/[A-Z]+/, line)
          {pair, insert}
        end)

      {polymer, new_pairs}
    end

    @spec execute({polymer(), pairs()}, integer()) :: integer()
    def execute({polymer, pairs}, max_steps) do
      polymer
      |> build_frequencies()
      |> do_steps(pairs, max_steps)
      |> do_substract()
    end

    defp build_frequencies(polymer) do
      pair_counts =
        polymer
        |> do_chunk()
        |> Enum.frequencies()

      char_counts =
        polymer
        |> String.split("", trim: true)
        |> Enum.frequencies()

      {pair_counts, char_counts}
    end

    defp do_chunk(<<element1, element2, rest::binary>>) do
      [<<element1, element2>> | do_chunk(<<element2>> <> rest)]
    end

    defp do_chunk(_), do: []

    defp do_steps({_, char_counts}, _, 0), do: char_counts

    defp do_steps({pair_counts, char_counts}, pairs, max_steps) do
      pair_counts
      |> Enum.reduce({%{}, char_counts}, fn {pair, count}, {acc_pairs, acc_chars} ->
        insert = Map.fetch!(pairs, pair)
        <<first, second>> = pair

        new_left = <<first>> <> insert
        new_right = insert <> <<second>>

        new_pairs = update_pairs(acc_pairs, [new_left, new_right], count)
        new_chars = Map.update(acc_chars, insert, count, &(&1 + count))

        {new_pairs, new_chars}
      end)
      |> do_steps(pairs, max_steps - 1)
    end

    defp update_pairs(pairs, keys, count) do
      Enum.reduce(keys, pairs, fn key, acc ->
        Map.update(acc, key, count, &(&1 + count))
      end)
    end

    defp do_substract(frequency) do
      {{_, min}, {_, max}} = Enum.min_max_by(frequency, &elem(&1, 1))
      max - min
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.execute(10)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.execute(40)
    end
  end
end
